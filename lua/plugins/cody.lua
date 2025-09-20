-- ~/.config/nvim/lua/plugins/codeium.lua
return {
  {
    "Exafunction/codeium.vim",
    config = function()
      -- optional: disable suggestion preview if you want
      vim.g.codeium_disable_bindings = 1
      vim.g.codeium_debug = true

      -- Trigger Codeium suggestions
      vim.keymap.set("i", "<C-Space>", function()
        vim.fn["codeium#Complete"]()
      end, { silent = true })

      -- Accept full multi-line suggestion with <C-l>
      vim.keymap.set("i", "<C-l>", function()
        local suggestion = vim.fn["codeium#Accept"]()
        if suggestion ~= "" then
          -- feed the keys so that multi-line suggestions insert correctly
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(suggestion, true, false, true), "i", true)
        end
      end, { silent = true })

      -- Dismiss suggestion
      vim.keymap.set("i", "<C-E>", function()
        vim.fn["codeium#Dismiss"]()
      end, { silent = true })
    end,
  },
}
