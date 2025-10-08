return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
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
    },
    highlight = {
      enable = true,
    },
  },
}
