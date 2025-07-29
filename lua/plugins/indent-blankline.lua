return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "│", -- thin vertical line
      },
      scope = {
        enabled = false, -- disable bold scope line under cursor
      },
    },
    config = function(_, opts)
      local ibl = require("ibl")
      ibl.setup(opts)

      -- Optional: subtle indent color
      vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3b3b3b", nocombine = true })
    end,
  },
}
