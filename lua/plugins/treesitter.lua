return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
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
    injections = {
      enable = true,
    },
  },
}
