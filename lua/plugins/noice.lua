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
          enabled = false, -- Unchanged: Prevents noice.nvim from rendering signature help
        },
        hover = {
          enabled = true, -- Unchanged: Allows noice.nvim to handle hover popups
          silent = true, -- Added: Prevents hover popup from stealing focus
          opts = {
            border = "rounded", -- Added: Rounded border for hover popup
            max_width = 80, -- Added: Limits popup width
            max_height = 20, -- Added: Limits popup height
            focusable = false, -- Added: Ensures popup is not focusable
          },
        },
        -- Added: Override LSP hover handler to strip diagnostics
        override = {
          ["vim.lsp.buf.hover"] = true, -- Ensures noice.nvim handles hover
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
