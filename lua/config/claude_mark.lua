local ns = vim.api.nvim_create_namespace("claude_mark")

local preview_winid = nil

local function preview_win()
  if preview_winid and vim.api.nvim_win_is_valid(preview_winid) then
    return preview_winid
  end
  vim.cmd("botright vsplit")
  preview_winid = vim.api.nvim_get_current_win()
  return preview_winid
end

local function mark(file, first, last, label)
  first = tonumber(first) or 1
  last = tonumber(last) or first

  local origin = vim.api.nvim_get_current_win()

  local win = preview_win()
  vim.api.nvim_win_call(win, function()
    vim.cmd("edit " .. vim.fn.fnameescape(file))
  end)
  local buf = vim.api.nvim_win_get_buf(win)

  local n = vim.api.nvim_buf_line_count(buf)
  first = math.max(1, math.min(first, n))
  last = math.max(first, math.min(last, n))

  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  for ln = first, last do
    vim.api.nvim_buf_set_extmark(buf, ns, ln - 1, 0, {
      line_hl_group = "Visual",
      sign_text = "▶",
      sign_hl_group = "DiagnosticSignWarn",
    })
  end

  vim.api.nvim_win_set_cursor(win, { first, 0 })
  vim.api.nvim_win_call(win, function()
    vim.cmd("normal! zz")
  end)

  -- Restore focus; re-enter terminal insert mode if that is where they were.
  if vim.api.nvim_win_is_valid(origin) then
    vim.api.nvim_set_current_win(origin)
    if vim.bo[vim.api.nvim_win_get_buf(origin)].buftype == "terminal" then
      vim.cmd("startinsert")
    end
  end

  if label and label ~= "" then
    vim.api.nvim_echo({ { "Claude: " .. label, "WarningMsg" } }, false, {})
  end
  return string.format("%s:%d-%d", vim.fn.fnamemodify(file, ":."), first, last)
end

-- Clear markers from every loaded buffer.
local function clear()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    end
  end
  return "cleared"
end

-- Globals are the RPC entry points Claude calls via --remote-expr luaeval().
_G.ClaudeMark = mark
_G.ClaudeMarkClear = clear

-- :ClaudeMark marks the current buffer over a [range] (defaults to current line).
vim.api.nvim_create_user_command("ClaudeMark", function(opts)
  mark(vim.api.nvim_buf_get_name(0), opts.line1, opts.line2, "manual mark")
end, { range = true })

vim.api.nvim_create_user_command("ClaudeMarkClear", clear, {})
