return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>ss",
        function()
          require("telescope.builtin").lsp_document_symbols({
            symbols = {
              "function",
              "method",
              "class",
              "interface",
              "struct",
              "enum",
              "constant",
              "variable",
            },
            symbol_width = 50,
            fname_width = 40,
          })
        end,
        desc = "Document Symbols",
      },
      {
        "<leader>sm",
        function()
          require("telescope.builtin").marks()
        end,
        desc = "Marks",
      },
    },
  },
}
