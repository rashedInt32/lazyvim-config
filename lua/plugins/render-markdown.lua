return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- needs markdown + markdown_inline parsers
    "nvim-mini/mini.icons", -- icon provider (already used by oil.nvim)
  },
  ft = { "markdown" },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    pipe_table = {
      preset = "round", -- nicer rounded borders
      cell = "trimmed", -- drop unused padding so tables stay as narrow as possible
    },
  },
}
