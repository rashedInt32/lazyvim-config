return {
  "rashedInt32/lazydiff.nvim",
  cmd = { "Lazydiff", "LazydiffOff", "LazydiffRefresh", "LazydiffFloat", "LazydiffFloatOff" },
  keys = {
    -- Swapped from the README's suggested layout: the float is the one reached
    -- for most, so it gets the cheaper key. Upstream defaults are unchanged.
    { "<leader>dd", "<cmd>LazydiffFloat<cr>", desc = "Lazydiff float (all changes)" },
    { "<leader>dD", "<cmd>Lazydiff<cr>", desc = "Toggle lazydiff overlay (this file)" },
  },
  config = function()
    require("lazydiff").setup({
      -- Fill the editor area vertically; the upstream default (0.9) leaves a
      -- couple of rows top and bottom. Drop to 0.95 for a one-row margin.
      float = { height = 1.0 },
    })
  end,
}
