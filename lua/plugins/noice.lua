return {
  {
    "folke/noice.nvim",
    priority = 1000,
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      cmdline = {
        view = "cmdline",
      },
      presets = { command_palette = false },
      lsp = {
        signature = {
          enabled = false,
        },
        hover = {
          enabled = true,
        },
      },
    },
    config = function(_, opts)
      require("noice").setup(opts)
      -- Override LSP hover to strip diagnostics from type hover
    end,
  },
}
