return {
  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("undotree").setup()
    end,
    keys = {
      -- <leader>U, not <leader>u: the latter shadowed every Snacks toggle on
      -- the <leader>u* prefix (ud, ug, uh, ul, uL, us, uw, uc, ub, uD, uT, uC,
      -- un), delaying all of them by timeoutlen.
      {
        "<leader>U",
        function()
          require("undotree").toggle()
        end,
        desc = "Toggle Undotree",
      },
    },
    init = function()
      vim.opt.undofile = true
      vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
    end,
  },
}
