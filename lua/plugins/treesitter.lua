return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      -- Enable syntax highlighting
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false, -- Avoid regex-based highlights
      },
      -- Disable features that might cause word highlighting
      incremental_selection = { enable = false },
      textobjects = { enable = false },
      -- Ensure parsers are installed for your languages
      ensure_installed = { "lua", "vim", "python", "prisma", "elixir", "heex", "eex" }, -- Adjust based on your needs
    })
  end,
}
