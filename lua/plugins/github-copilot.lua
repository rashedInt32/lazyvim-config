return {
  -- Copilot Lua
  {
    "zbirenbaum/copilot.lua",
    dependencies = {
      "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
      init = function()
        vim.g.copilot_nes_debounce = 500
      end,
    },
    cmd = "Copilot",
    enabled = true,
    event = "InsertEnter",
    copilot_model = "claude-sonnet-4.5",
    opts = {
      suggestion = {
        enabled = false, -- Disable to avoid conflicts with blink-cmp-copilot
        auto_trigger = false,
        debounce = 75,
        keymap = {
          accept = "<C-f>", -- Accept suggestion with Ctrl+F
          dismiss = "<C-]>", -- Dismiss suggestion
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
        },
        filetypes = {
          javascript = true,
          typescript = true,
          javascriptreact = true,
          typescriptreact = true,
          lua = true,
          python = true,
          go = true,
          html = true,
          css = true,
          vue = true,
          svelte = true,
          elixir = true,
          heex = true,
          ["*"] = false, -- Disable for other filetypes
        },
        nes = {
          enabled = true, -- Enable NES (Next Edit Suggestion) feature
          auto_trigger = false, -- Disable auto-trigger to avoid conflicts
          keymap = {
            accept = "<C-f>", -- Accept next edit suggestion with Ctrl+F
            next = "<C-]>",
            prev = "<C-[>",
            dismiss = "<C-}>",
          },
        },
      },
      panel = {
        enabled = false, -- Disable Copilot panel
      },
      filetypes = {
        ["*"] = true, -- Enable for all filetypes
      },
    },
    config = function(_, opts)
      require("copilot").setup(opts)

      -- Ensure <Esc> clears suggestions
      vim.keymap.set("i", "<Esc>", function()
        if require("copilot.suggestion").is_visible() then
          require("copilot.suggestion").dismiss()
        end
        return "<Esc>"
      end, { expr = true, noremap = true })

      -- 🔥 Reapply Ctrl+F mapping to ensure CopilotChat doesn't override it
      vim.api.nvim_set_keymap("i", "<C-f>", 'copilot#Accept("<CR>")', { expr = true, silent = true })

      -- Tab for NES accept in normal mode
      vim.keymap.set("n", "<Tab>", function()
        require("copilot.suggestion").accept()
      end, { silent = true })
    end,
  },

  -- Disable copilot.vim (to prevent conflicts)
  {
    "github/copilot.vim",
    enabled = false,
  },
}
