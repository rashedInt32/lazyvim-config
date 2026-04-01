return {
  {
    "supermaven-inc/supermaven-nvim",
    enabled = false,
    event = "InsertEnter",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<C-f>", -- Accept with Ctrl+F
          clear_suggestion = "<C-]>", -- Clear suggestion
          accept_word = "<C-l>", -- Alternative accept word with Ctrl+L
        },
        color = {
          suggestion_color = "#5c6370",
          cterm = 59,
        },
        log_level = "info",
        disable_inline_completion = false,
        disable_keymaps = false,
      })
    end,
  },
}
