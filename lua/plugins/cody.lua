-- ~/.config/nvim/lua/plugins/codeium.lua
return {
  {
    "Exafunction/windsurf.vim",
    config = function()
      vim.g.codeium_enabled = false

      -- Optional: disable default keybindings
      vim.g.windsurf_disable_default_mappings = 1
      vim.g.windsurf_debug = true

      -- Trigger Codeium suggestions
      vim.keymap.set("i", "<C-Space>", function()
        vim.fn["codeium#Complete"]()
      end, { silent = true })

      vim.keymap.set("i", "<C-l>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true, silent = true })
      -- Dismiss suggestion
      vim.keymap.set("i", "<C-E>", function()
        vim.fn["codeium#Dismiss"]()
      end, { silent = true })
    end,
  },
}
