-- ~/.config/nvim/lua/autocmd.lua

-- Close floating terminals safely
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  pattern = "*",
  callback = function()
    local status_ok, toggleterm = pcall(require, "toggleterm.terminal")
    if not status_ok then
      return
    end

    -- iterate through all terminals
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

vim.api.nvim_create_user_command("TestLualine", function()
  config_lualine(colors)
  vim.o.laststatus = vim.g.lualine_laststatus
  print("✓ Test lualine config loaded")
end, {})

vim.api.nvim_create_user_command("ResetLualine", function()
  require("lazy").reload({ plugins = { "lualine.nvim" } })
  print("✓ Reset to original lualine config")
end, {})
