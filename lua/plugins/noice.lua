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
        lsp_doc_border = true, -- Move this here from the second setup call
        bottom_search = true,
        long_message_to_split = true,
        inc_rename = false,
      },
      lsp = {
        -- COMPLETELY DISABLE Noice's signature handling
        signature = {
          enabled = false,
          auto_open = {
            enabled = false,
          },
        },
        -- Disable hover as well since you're handling it elsewhere
        hover = {
          enabled = false,
          silent = true,
        },
        -- This is crucial: disable message override for signature help
        message = {
          enabled = false, -- Disable all LSP messages from Noice
        },
        override = {
          -- Explicitly disable signature help override
          ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
          ["vim.lsp.util.stylize_markdown"] = false,
          ["cmp.entry.get_documentation"] = false,
        },
      },
      routes = {
        {
          filter = {
            event = "notify",
            find = "No information available",
          },
          opts = { skip = true },
        },
        -- Add route to filter out any remaining signature messages
        {
          filter = {
            event = "lsp",
            kind = "signature_help",
          },
          opts = { skip = true },
        },
      },
    },
    config = function(_, opts)
      require("noice").setup(opts)

      -- Additional safety: manually disable Noice's LSP handlers
      vim.api.nvim_create_autocmd("User", {
        pattern = "NoiceEnabled",
        callback = function()
          -- Ensure Noice doesn't interfere with signature help
          package.loaded["noice.lsp.signature"] = nil
        end,
      })
    end,
  },
}
