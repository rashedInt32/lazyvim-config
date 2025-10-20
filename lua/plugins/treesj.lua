return {
  {
    "Wansmer/treesj",
    keys = {
      { "gS", "<cmd>TSJSplit<CR>", desc = "Split to multiple lines" },
      { "gJ", "<cmd>TSJJoin<CR>", desc = "Join to single line" },
    },
    opts = {
      use_default_keymaps = false,
      max_join_length = 200,
    },
  },
}
