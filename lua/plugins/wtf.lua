return {
  {
    "davidosomething/format-ts-errors.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    config = function()
      require("format-ts-errors").setup({
        add_markdown = true,
        start_indent_level = 0,
      })
    end,
  },
}
