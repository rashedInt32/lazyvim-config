return {
  -- Copilot Lua
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    enabled = true,
    event = "InsertEnter",
    copilot_model = "claude-3.5-sonnet",
    opts = {
      suggestion = {
        enabled = false, -- Disable to avoid conflicts with blink-cmp-copilot
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = "<C-f>", -- Accept suggestion with Ctrl+F
          dismiss = "<C-]>", -- Dismiss suggestion
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
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
    end,
  },

  -- Disable copilot.vim (to prevent conflicts)
  {
    "github/copilot.vim",
    enabled = false,
  },
}
