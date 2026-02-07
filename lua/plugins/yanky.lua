return {
  "gbprod/yanky.nvim",
  opts = {
    ring = {
      storage = "shada",
      ignore_registers = { "_" },
    },
    system_clipboard = {
      sync_with_ring = true,
    },
    highlight = {
      on_put = true,
      on_yank = true,
      timer = 200,
    },
  },
  keys = {
    -- NOTE: Explicitly NOT including <leader>p mapping to avoid conflict with black hole paste
    -- LazyVim default maps <leader>p to yank history picker - we're disabling that here
    { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
    { "p", "<Plug>(YankyPutAfter)", mode = { "n" }, desc = "Put yanked text after cursor" },
    { "P", "=P", mode = "n", remap = true, desc = "Put before with auto-indent" },
    { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after selection" },
    { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before selection" },
    { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle forward through yank history" },
    { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle backward through yank history" },
    { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
    { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
    { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
    { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
    { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and indent right" },
    { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and indent left" },
    { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and indent right" },
    { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put before and indent left" },
    { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },
    { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before applying a filter" },
    -- Alternative keymap for yank history (since <leader>p is used for black hole paste)
    { "<leader>sy", function() require("snacks").picker.yanky() end, mode = { "n", "x" }, desc = "Yank History" },
  },
  config = function(_, opts)
    require("yanky").setup(opts)
    -- Clear LazyVim's default <leader>p mapping and set our black hole paste
    pcall(vim.keymap.del, "x", "<leader>p")
    vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without yanking (black hole)" })
  end,
}
