-- Hide tmux's status bar while nvim owns the pane, so it doesn't stack
-- underneath lualine. Restore it when we hand the screen back.
--
-- Replaces tmux-status.nvim, which we only ever used for this side effect.

if not vim.env.TMUX then
  return
end

-- Target the pane explicitly. Untargeted `tmux set` applies to whichever
-- client tmux used last, which may not be the one running this nvim.
local pane = vim.env.TMUX_PANE

local function tmux(args, sync)
  local cmd = { "tmux" }
  vim.list_extend(cmd, args)
  if sync then
    -- On VimLeavePre we may exit before an async child gets to run.
    return vim.system(cmd, { text = true }):wait(1000)
  end
  return vim.system(cmd, { text = true }, function() end)
end

-- Read this before hiding anything, or we'd record our own "off" as the
-- original. `status` takes a line count as well as on/off, so keep the string.
local original = "on"
local shown = tmux({ "show", "-t", pane, "-v", "status" }, true)
if shown.code == 0 and vim.trim(shown.stdout) ~= "" then
  original = vim.trim(shown.stdout)
end

local hidden = false

local function hide()
  hidden = true
  tmux({ "set-option", "-t", pane, "status", "off" })
end

---@param sync boolean
local function restore(sync)
  if not hidden then
    return
  end
  hidden = false
  tmux({ "set-option", "-t", pane, "status", original }, sync)
end

hide()

vim.api.nvim_create_autocmd({ "FocusGained", "VimResume" }, {
  desc = "Hide tmux status bar",
  callback = hide,
})

vim.api.nvim_create_autocmd({ "FocusLost", "VimSuspend" }, {
  desc = "Restore tmux status bar",
  callback = function()
    restore(false)
  end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  desc = "Restore tmux status bar before exiting",
  callback = function()
    restore(true)
  end,
})
