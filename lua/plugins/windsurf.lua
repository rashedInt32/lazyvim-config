return {
  {
    "Exafunction/windsurf.vim",
    config = function()
      vim.g.codeium_enabled = false
      vim.g.windsurf_disable_default_mappings = 1
      vim.g.windsurf_debug = true

      vim.keymap.set("i", "<C-Space>", function()
        vim.fn["codeium#Complete"]()
      end, { silent = true })

      vim.keymap.set("i", "<C-l>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true, silent = true })

      vim.keymap.set("i", "<C-E>", function()
        vim.fn["codeium#Dismiss"]()
      end, { silent = true })
    end,
  },
}
