return {
  -- Local checkout so plugin edits apply instantly. Swap `dir` for
  -- "rashedInt32/switcheroo.nvim" once it is published.
  dir = "~/Documents/codes/packages/switcheroo.nvim",
  name = "switcheroo.nvim",
  cmd = "Switcheroo",
  keys = {
    -- `<leader>r` alone is mapped too, so `<leader>r` + a stray letter opens the
    -- popup instead of falling through to Vim's `r{char}` (which overwrites a
    -- visual selection or the character under the cursor).
    {
      "<leader>r",
      function()
        require("switcheroo").open()
      end,
      mode = { "n", "x" },
      desc = "Replace in buffer (switcheroo)",
    },
    {
      "<leader>rr",
      function()
        require("switcheroo").open()
      end,
      mode = { "n", "x" },
      desc = "Replace in buffer (switcheroo)",
    },
    {
      "<leader>r.",
      function()
        require("switcheroo").repeat_last()
      end,
      desc = "Repeat last replace (switcheroo)",
    },
  },
  opts = {},
}
