return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    ensure_installed = {
      "lua",
      "typescript",
      "javascript",
      "tsx",
      "markdown",
      "markdown_inline",
      "bash",
      "vim",
      "vimdoc",
      "tsv",
      "sql",
    },
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
    -- No `injections` key: LazyVim's main-branch spec only reads highlight,
    -- indent and folds, so it was inert. Injections come from the queries in
    -- after/queries/, which need no opt-in.
  },
}
