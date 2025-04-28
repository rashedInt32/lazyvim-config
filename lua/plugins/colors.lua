return {
  "folke/tokyonight.nvim",
  lazy = true,
  opts = {
    style = "day", -- Or your preferred style
    transparent = true,
    -- You might also want to make sidebar and float backgrounds transparent
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
  },
}