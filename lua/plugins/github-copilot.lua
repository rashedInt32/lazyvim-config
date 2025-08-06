return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    enabled = false,
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true, -- Enable inline suggestions
        auto_trigger = true, -- Automatically show suggestions
        debounce = 75, -- Debounce to reduce suggestion flickering
        keymap = {
          accept = "<C-f>", -- Accept suggestion with Ctrl+f
          dismiss = "<C-]>", -- Dismiss suggestion with Ctrl+]
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
      -- Ensure <Esc> clears suggestions to prevent cursor jumps
      vim.keymap.set("i", "<Esc>", function()
        if require("copilot.suggestion").is_visible() then
          require("copilot.suggestion").dismiss()
        end
        return "<Esc>"
      end, { expr = true, noremap = true })
    end,
  },
  {
    "github/copilot.vim",
    enabled = false, -- Disable copilot.vim to avoid cursor jumps
  },
}
