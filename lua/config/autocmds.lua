-- ~/.config/nvim/lua/autocmd.lua

-- Configure diagnostics
vim.api.nvim_create_autocmd({ "BufEnter", "LspAttach" }, {
  callback = function()
    vim.diagnostic.config({
      update_in_insert = false,
      severity_sort = true,
      float = false,
      virtual_text = false,
      signs = true,
      underline = true,
      jump = { float = false, wrap = true },
    })
  end,
})

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
