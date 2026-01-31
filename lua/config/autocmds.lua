-- ~/.config/nvim/lua/autocmd.lua

-- Close floating terminals safely (only when toggleterm is loaded)
local toggleterm_loaded = false
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyLoad",
  callback = function(args)
    if args.data == "toggleterm.nvim" then
      toggleterm_loaded = true
    end
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave" }, {
  pattern = "*",
  callback = function()
    if not toggleterm_loaded then
      return
    end
    local toggleterm = require("toggleterm.terminal")
    for _, term in pairs(toggleterm.get_all()) do
      if term.direction == "float" and vim.api.nvim_win_is_valid(term.window) then
        term:close()
      end
    end
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkLoaded",
  callback = function()
    vim.api.nvim_del_keymap("i", "<C-F>")
  end,
})
