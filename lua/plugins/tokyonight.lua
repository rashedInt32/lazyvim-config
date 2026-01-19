return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "night",
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
      hl.Comment = {
        fg = "#6772a4",
        italic = true,
      }
    end,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight")

    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "tokyonight",
      callback = function()
        vim.api.nvim_set_hl(0, "Visual", { bg = "#2d3f5f" })
        vim.api.nvim_set_hl(0, "CursorLine", { bg = "#021320" })
        vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#5a6a8a" })
        vim.api.nvim_set_hl(0, "BlinkCmpGhostText", { fg = "#5a6a8a" })
        vim.api.nvim_set_hl(0, "Comment", { fg = "#6772a4", italic = true })
      end,
    })
  end,
}
