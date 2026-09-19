return {
  -- Local checkout while the plugin is in development. Switch to
  -- "rashedInt32/jev-lens.nvim" once it is published.
  dir = vim.fn.expand("~/Documents/codes/packages/jev-lens.nvim"),
  name = "jev-lens.nvim",
  event = "VeryLazy",
  cmd = { "JevLens" },
  keys = {
    { "<leader>jl", "<cmd>JevLens toggle<cr>", desc = "jev-lens: toggle verdict" },
    { "<leader>jj", "<cmd>JevLens judge<cr>", desc = "jev-lens: judge now" },
    { "<leader>jr", "<cmd>JevLens reviewed<cr>", desc = "jev-lens: mark reviewed" },
  },
  config = function()
    require("jev-lens").setup({
      -- No popup for a verdict that was already pending when nvim opened.
      -- Verdicts written during the session still show. <leader>jl on demand.
      on_startup = false,
      -- Points at the checkout so `R` and :JevLens judge work before the hook
      -- plugin is published. Remove once jev-lens is installed from a
      -- marketplace; the plugin then finds the judge in the plugin cache.
      judge_cmd = { "node", vim.fn.expand("~/Documents/codes/packages/jev-lens/bin/judge.mjs") },
    })
  end,
}
