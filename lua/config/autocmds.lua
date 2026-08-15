-- ~/.config/nvim/lua/autocmd.lua

vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkLoaded",
  callback = function()
    vim.api.nvim_del_keymap("i", "<C-F>")
  end,
})

-- Theme switching lived here, but rose-pine is now the only colorscheme.
-- Snacks.picker.colorschemes() (snacks.lua) covers ad-hoc switching.
