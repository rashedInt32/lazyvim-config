return {
  {
    "folke/trouble.nvim",
    config = function(_, opts)
      require("trouble").setup(opts)
      -- CHANGED: Ensured no BufWinEnter autocommand to prevent floating diagnostics
    end,
  },
}
