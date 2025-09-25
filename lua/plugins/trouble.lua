return {
  {
    "folke/trouble.nvim",
    opts = {

      multiline = true, -- show diagnostics in multiple lines
      indent_lines = true,
      auto_open = false,
      auto_close = false,
    },
    config = function(_, opts)
      require("trouble").setup(opts)
      -- CHANGED: Ensured no BufWinEnter autocommand to prevent floating diagnostics
    end,
  },
}
