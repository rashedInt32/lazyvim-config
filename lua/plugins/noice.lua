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
      presets = {
        command_palette = false,
      },
      lsp = {
        signature = {
          enabled = false,
        },
        hover = {
          enabled = true,
          silent = true,
          opts = {
            border = "rounded",
            max_width = 80,
            max_height = 20,
            focusable = false,
          },
        },
        -- REMOVED: override = { ["vim.lsp.buf.hover"] = false } to simplify, handled in lsp-config.lua
      },
    },
    config = function(_, opts)
      require("noice").setup(opts)
      -- REMOVED: Custom vim.lsp.buf.hover function to simplify, handled in lsp-config.lua
    end,
  },
}
