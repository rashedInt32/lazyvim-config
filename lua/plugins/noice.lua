return {
  {
    "folke/noice.nvim",
    priority = 1000,
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = function()
      -- Calculate dynamic sizes based on current screen
      local columns = vim.o.columns
      local lines = vim.o.lines

      return {
        cmdline = {
          view = "cmdline",
        },
        presets = {
          command_palette = false,
          bottom_search = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = true,
        },
        lsp = {
          signature = {
            enabled = true,
            auto_open = {
              enabled = true,
              trigger = true,
              throttle = 50,
            },
            opts = {
              border = "rounded",
              max_width = math.floor(columns * 0.8),
              max_height = math.floor(lines * 0.6),
              wrap = true,
              focusable = false,
              relative = "cursor",
              zindex = 50,
              padding = { top = 1, bottom = 1, left = 2, right = 2 },
              -- Enable scrolling in the signature window
              scrollable = true,
            },
          },
          hover = {
            enabled = true,
            silent = false,
            opts = {
              border = "rounded",
              max_width = math.floor(columns * 0.8),
              max_height = math.floor(lines * 0.6),
              wrap = true,
              focusable = false,
              padding = { top = 1, bottom = 1, left = 2, right = 2 },
            },
          },
          message = {
            enabled = true,
          },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        views = {
          hover = {
            border = {
              style = "rounded",
              padding = { 1, 2 },
            },
            position = { row = 2, col = 2 },
            size = {
              max_width = math.floor(columns * 0.8) - 4,
              max_height = math.floor(lines * 0.6) - 4,
            },
            win_options = {
              wrap = true,
              linebreak = true,
            },
          },
          signature = {
            border = {
              style = "rounded",
              padding = { 1, 2 },
            },
            position = { row = 1, col = 2 },
            size = {
              max_width = math.floor(columns * 0.7) - 4,
              max_height = math.floor(lines * 0.4) - 4,
            },
            win_options = {
              wrap = true,
              linebreak = true,
            },
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
          {
            filter = {
              event = "msg_show",
              min_height = 10,
            },
            view = "split",
          },
        },
      }
    end,
    config = function(_, opts)
      require("noice").setup(opts)

      -- Refresh Noice on window resize for dynamic sizing
      vim.api.nvim_create_autocmd("VimResized", {
        callback = function()
          -- Use the correct Noice API to dismiss all messages
          pcall(function()
            -- Try different approaches to dismiss Noice windows
            local noice = require("noice")

            -- Method 1: Use the command directly
            vim.cmd("Noice dismiss")

            -- Method 2: Alternatively, use the API if available
            if noice.api and noice.api.dismiss then
              noice.api.dismiss()
            end

            -- Method 3: Clear all messages
            if noice.message then
              noice.message.clear()
            end
          end)
        end,
      })
    end,
  },
}
