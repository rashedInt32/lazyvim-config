return {
  -- Local checkout so plugin edits apply instantly. Published at
  -- https://github.com/rashedInt32/sidekick-zen.nvim — swap `dir` for
  -- "rashedInt32/sidekick-zen.nvim" to consume the GitHub version instead.
  dir = "~/Documents/codes/sidekick-zen.nvim",
  name = "sidekick-zen.nvim",
  dependencies = { "folke/sidekick.nvim" },
  keys = {
    {
      "<leader>z",
      function()
        require("sidekick-zen").toggle()
      end,
      desc = "Toggle Zen Workspace",
    },
  },
  opts = {},
}
