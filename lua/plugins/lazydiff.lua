return {
  "rashedInt32/lazydiff.nvim",
  cmd = { "Lazydiff", "LazydiffOff", "LazydiffRefresh" },
  keys = {
    { "<leader>dd", "<cmd>Lazydiff<cr>", desc = "Toggle lazydiff overlay" },
  },
  config = function()
    require("lazydiff").setup()
  end,
}
