-- ~/.config/nvim/lua/autocmd.lua

vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkLoaded",
  callback = function()
    vim.api.nvim_del_keymap("i", "<C-F>")
  end,
})

-- Theme switching commands and autocmds
vim.api.nvim_create_user_command("ThemeRosePineMoon", function()
  vim.cmd("colorscheme rose-pine")
  vim.notify("Switched to Rosé Pine Moon theme", vim.log.levels.INFO)
end, { desc = "Switch to Rosé Pine Moon theme" })

vim.api.nvim_create_user_command("ThemeTokyoNight", function()
  vim.cmd("colorscheme tokyonight")
  vim.notify("Switched to Tokyo Night theme", vim.log.levels.INFO)
end, { desc = "Switch to Tokyo Night theme" })

-- Keymaps for quick theme switching
vim.keymap.set("n", "<leader>tm", "<cmd>ThemeRosePineMoon<cr>", { desc = "Theme: Rosé Pine Moon" })
vim.keymap.set("n", "<leader>tt", "<cmd>ThemeTokyoNight<cr>", { desc = "Theme: Tokyo Night" })
