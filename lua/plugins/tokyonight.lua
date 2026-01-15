return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "moon",
    transparent = true,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
      comments = { italic = true },
      keywords = { italic = true },
      functions = { italic = true },
      conditionals = {},
      loops = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
      operators = {},
    },
    on_highlights = function(hl, c)
      hl.CursorLine = {
        bg = "#021320",
      }
      hl.Visual = {
        bg = "#2d3f5f",
      }
      hl.CopilotSuggestion = {
        fg = "#5a6a8a",
      }
      hl.BlinkCmpGhostText = {
        fg = "#5a6a8a",
      }
    end,
  },
}
