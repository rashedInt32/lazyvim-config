return {
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
  }),
}
