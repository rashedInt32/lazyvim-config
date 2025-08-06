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
          enabled = false,
          silent = true,
          opts = {
            border = "rounded",
            max_width = 80,
            max_height = 20,
            focusable = false,
          },
        },
        -- Added: Override LSP hover handler to strip diagnostics
        override = {
          ["vim.lsp.buf.hover"] = false,
        },
      },
    },
    config = function(_, opts)
      require("noice").setup(opts)
      -- Added: Filter diagnostics from hover content
      local original_hover = vim.lsp.buf.hover
      vim.lsp.buf.hover = function(...)
        local bufnr, winnr = original_hover(...)
        if bufnr and winnr then
          local contents = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
          local filtered = {}
          for _, line in ipairs(contents) do
            if not line:match("^%s*diagnostics:%s*$") and not line:match("^%s*- %w+:") then
              table.insert(filtered, line)
            end
          end
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, filtered)
        end
        return bufnr, winnr
      end
    end,
  },
}
