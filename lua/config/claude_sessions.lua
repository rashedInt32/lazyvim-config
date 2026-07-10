-- Ambient indicator for every Claude Code agent running on this machine.
--
-- Claude writes ~/.claude/sessions/<pid>.json for each agent, carrying a live
-- `status` field (waiting | idle | busy). Reading those directly is what
-- tmux-claude-session-manager's scripts/agents.sh does, and it means this needs
-- no hooks in settings.json and no `claude agents --json` (~210ms of node).
--
-- Scope is deliberately machine-wide and read-only: every agent counts, whether
-- it lives in a sidekick.nvim split, a bare tmux pane, or this nvim's own cwd.
-- sidekick and the tmux manager stay the only things that spawn or attach;
-- `prefix+u` (or <leader>au) is what acts on what this reports.

local uv = vim.uv or vim.loop

local M = {}

M.config = {
  dir = (vim.env.CLAUDE_CONFIG_DIR or (vim.env.HOME .. "/.claude")) .. "/sessions",
  poll_ms = 1000, -- re-read the session files
  spin_ms = 120, -- spinner frame cadence, only ticks while something is busy
  max_dots = 10, -- past this, the tail collapses to a dim `+N`
  -- The agent running in this nvim's own cwd is the one you can already see in
  -- the sidekick split, so it renders dimmed (and never counts against the cap).
  dim_own = true,
  dim_alpha = 0.55, -- fraction of the state color kept; rest blends into the bar
  -- Per-state dot colors. Idle is a brighter green than oldworld's muted
  -- palette.green (#90b99f), which washed out against the dark bar.
  colors = {
    waiting = "#f5d76e", -- bright yellow: blocked on you
    busy = "#f2555a", -- urgent red: working
    idle = "#7fe08a", -- bright green: alive, parked
    more = "#9f9ca6", -- dim: the `+N` overflow marker
  },
}

-- One nf-md circle family, so all states share a glyph width and the bar doesn't
-- jitter as agents change state. Solid dots with the state in the color, like
-- the tmux picker's rows; busy additionally animates.
local icons = {
  waiting = "󰝥", -- solid, yellow: blocked on you
  idle = "󰝥", -- solid, green: alive, nothing happening
  -- circle-slice frames: an actual progress ring rather than a braille spinner
  busy = { "󰪞", "󰪟", "󰪠", "󰪡", "󰪢", "󰪣", "󰪤", "󰪥" },
}

local state = { waiting = {}, busy = {}, idle = {} }
local frame = 1
local rendered = ""
local poll_timer, spin_timer
local set_highlights -- forward decl; defined below, re-asserted on the draw path

--- A session file outlives an agent killed with SIGKILL, so a recycled PID can
--- surface a phantom row. Signal 0 checks existence without delivering anything.
--- (agents.sh additionally matches the command line to rule out a recycled PID
--- that is some *other* live process; here a phantom costs a wrong glyph for a
--- moment, not a stray kill, so existence is guard enough.)
local function alive(pid)
  if type(pid) ~= "number" then
    return false
  end
  local ok, res = pcall(uv.kill, pid, 0)
  return ok and res == 0
end

local function read_json(path)
  local fd = io.open(path, "r")
  if not fd then
    return nil
  end
  local raw = fd:read("*a")
  fd:close()
  local ok, decoded = pcall(vim.json.decode, raw)
  return ok and decoded or nil
end

--- @return table<string, table[]> buckets keyed by status
function M.sessions()
  local out = { waiting = {}, busy = {}, idle = {} }
  local ok, entries = pcall(vim.fs.dir, M.config.dir)
  if not ok then
    return out
  end
  for name, kind in entries do
    if kind == "file" and name:sub(-5) == ".json" then
      local s = read_json(M.config.dir .. "/" .. name)
      if s and s.kind == "interactive" and out[s.status] and alive(s.pid) then
        table.insert(out[s.status], s)
      end
    end
  end
  return out
end

local function hl(group, text)
  return "%#ClaudeSess" .. group .. "#" .. text
end

--- Mix `fg` toward `bg` by keeping `alpha` of the foreground. Used to derive the
--- dimmed shade for your own session's dot.
local function blend(fg, bg, alpha)
  local function byte(hex, i)
    return tonumber(hex:sub(i, i + 1), 16)
  end
  local function mix(a, b)
    return math.floor(byte(fg, a) * alpha + byte(bg, b) * (1 - alpha) + 0.5)
  end
  return ("#%02x%02x%02x"):format(mix(2, 2), mix(4, 4), mix(6, 6))
end

--- One glyph per agent rather than one per state, so three agents read as three
--- dots. That's the count, without a digit.
local function dots(group, glyph, n)
  if n == 0 then
    return nil
  end
  local out = {}
  for _ = 1, n do
    out[#out + 1] = glyph
  end
  return hl(group, table.concat(out, " "))
end

local function render()
  -- Split each state into your own session (this nvim's cwd) and the rest. Own
  -- dots render dimmed and first; they're always shown since they're yours.
  local cwd = uv.cwd()
  local own = { waiting = 0, busy = 0, idle = 0 }
  local other = { waiting = 0, busy = 0, idle = 0 }
  for _, st in ipairs({ "waiting", "busy", "idle" }) do
    for _, s in ipairs(state[st]) do
      if M.config.dim_own and s.cwd == cwd then
        own[st] = own[st] + 1
      else
        other[st] = other[st] + 1
      end
    end
  end

  -- Spend the dot budget most-urgent-first over the *other* agents, so a bar that
  -- overflows still shows every agent that blocks you. Only a run of >max_dots
  -- ever loses a dot.
  local other_total = other.waiting + other.busy + other.idle
  local budget = math.min(other_total, M.config.max_dots)
  local function take(n)
    local shown = math.min(n, budget)
    budget = budget - shown
    return shown
  end

  local parts = {}
  local function push(part)
    parts[#parts + 1] = part
  end

  push(dots("OwnWaiting", icons.waiting, own.waiting))
  push(dots("OwnBusy", icons.busy[frame], own.busy))
  push(dots("OwnIdle", icons.idle, own.idle))
  push(dots("Waiting", icons.waiting, take(other.waiting)))
  push(dots("Busy", icons.busy[frame], take(other.busy)))
  push(dots("Idle", icons.idle, take(other.idle)))

  local hidden = other_total - math.min(other_total, M.config.max_dots)
  if hidden > 0 then
    push(hl("More", "+" .. hidden))
  end

  return table.concat(parts, " ")
end

local function refresh_if_changed()
  local text = render()
  if text == rendered then
    return
  end
  rendered = text
  vim.schedule(function()
    pcall(function()
      require("lualine").refresh({ place = { "statusline" } })
    end)
  end)
end

-- The spinner only runs while an agent is busy, so an all-idle machine costs
-- one wakeup per poll_ms rather than one per frame.
local function sync_spinner()
  if not spin_timer then
    return
  end
  if #state.busy > 0 then
    if not spin_timer:is_active() then
      spin_timer:start(M.config.spin_ms, M.config.spin_ms, function()
        frame = frame % #icons.busy + 1
        refresh_if_changed()
      end)
    end
  elseif spin_timer:is_active() then
    spin_timer:stop()
    frame = 1
  end
end

function M.poll()
  state = M.sessions()
  sync_spinner()
  refresh_if_changed()
end

--- Statusline string. Empty when no agent is running, so lualine hides it.
---
--- The dots carry inline `%#ClaudeSess*#` highlights. Those groups can be wiped
--- at runtime (a stray `:hi clear`, a colorscheme reload that doesn't fire our
--- autocmd, a plugin resetting groups) — when that happens the token falls back
--- to the default statusline fg and the dots render whitish. lualine calls this
--- on every draw, so re-asserting the groups when they've gone missing self-heals
--- within a redraw instead of staying broken until the next ColorScheme.
function M.status()
  if next(vim.api.nvim_get_hl(0, { name = "ClaudeSessIdle" })) == nil then
    set_highlights()
  end
  return rendered
end

function M.has_sessions()
  return rendered ~= ""
end

--- Open the tmux picker from nvim. Reuses scripts/list.sh so the popup opens on
--- the outer client and the `claude-*` popup-session handling stays in one place.
function M.pick()
  local list = vim.fn.expand("~/.tmux/plugins/tmux-claude-session-manager/scripts/list.sh")
  if vim.fn.executable(list) == 0 then
    return vim.notify("claude session picker not found: " .. list, vim.log.levels.WARN)
  end
  if not vim.env.TMUX then
    return vim.notify("Not inside tmux — the Claude picker needs a tmux client", vim.log.levels.WARN)
  end

  -- list.sh wants the client that "pressed the key". Resolve it from our pane's
  -- session rather than letting tmux guess a current client: with more than one
  -- client attached, guessing can detach an unrelated one.
  local client
  local pane = vim.env.TMUX_PANE
  if pane then
    local msg = { "tmux", "display-message", "-p", "-t", pane, "#{session_name}" }
    local session = vim.trim(vim.fn.system(msg))
    for _, line in ipairs(vim.fn.systemlist({ "tmux", "list-clients", "-F", "#{client_name} #{session_name}" })) do
      local name, sess = line:match("^(%S+)%s+(.*)$")
      if sess == session then
        client = name
        break
      end
    end
  end

  -- No client resolved: list.sh falls back to a popup on tmux's current client.
  local cmd = { list }
  if client then
    cmd[#cmd + 1] = client
  end

  -- display-popup blocks until the popup closes; detach so nvim keeps rendering.
  vim.system(cmd, { detach = true })
end

function set_highlights()
  local c = M.config.colors
  local bg = "#01111d" -- the lualine section background used in plugins/lualine.lua
  vim.api.nvim_set_hl(0, "ClaudeSessWaiting", { fg = c.waiting, bg = bg, bold = true })
  vim.api.nvim_set_hl(0, "ClaudeSessBusy", { fg = c.busy, bg = bg })
  vim.api.nvim_set_hl(0, "ClaudeSessIdle", { fg = c.idle, bg = bg })
  vim.api.nvim_set_hl(0, "ClaudeSessMore", { fg = c.more, bg = bg })
  -- Dimmed variants for your own session, blended toward the bar background.
  local a = M.config.dim_alpha
  vim.api.nvim_set_hl(0, "ClaudeSessOwnWaiting", { fg = blend(c.waiting, bg, a), bg = bg })
  vim.api.nvim_set_hl(0, "ClaudeSessOwnBusy", { fg = blend(c.busy, bg, a), bg = bg })
  vim.api.nvim_set_hl(0, "ClaudeSessOwnIdle", { fg = blend(c.idle, bg, a), bg = bg })
end

function M.setup()
  set_highlights()
  vim.api.nvim_create_autocmd("ColorScheme", { callback = set_highlights })

  poll_timer = uv.new_timer()
  spin_timer = uv.new_timer()
  poll_timer:start(0, M.config.poll_ms, M.poll)

  -- Coming back to the editor is exactly when you want a current answer.
  vim.api.nvim_create_autocmd("FocusGained", { callback = M.poll })

  vim.api.nvim_create_user_command("ClaudeSessions", M.pick, { desc = "Pick a running Claude session" })
end

return M
