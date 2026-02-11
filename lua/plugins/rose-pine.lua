return {
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = false,
  priority = 1000,
  opts = {
    variant = "main",
    dark_variant = "main",
    styles = {
      bold = true,
      italic = true,
      transparency = false,
    },

    palette = {
      main = {
        base = "#011627", -- Night Owl Background
        surface = "#011f35",
        overlay = "#0b2942",
        muted = "#6a8080", -- Night Owl Slate Comments
        subtle = "#82aaff",
        rose = "#ff7eb6",
        pine = "#7fdbca",
        foam = "#7dcfff",
        iris = "#c792ea",
        leaf = "#c3e88d",
        love = "#ff5189",
        -- TOKYONIGHT MATCH: The classic "e0af68" yellow.
        -- It's buttery, balanced, and premium.
        gold = "#0db9d7",

        -- bg = "#222436",
        -- bg_dark = "#1e2030",
        -- bg_dark1 = "#191B29",
        -- bg_highlight = "#2f334d",
        -- blue = "#82aaff",
        -- blue0 = "#3e68d7",
        -- blue1 = "#65bcff",
        -- blue2 = "#0db9d7",
        -- blue5 = "#89ddff",
        -- blue6 = "#b4f9f8",
        -- blue7 = "#394b70",
        -- comment = "#636da6",
        -- cyan = "#86e1fc",
        -- dark3 = "#545c7e",
        -- dark5 = "#737aa2",
        -- fg = "#c8d3f5",
        -- fg_dark = "#828bb8",
        -- fg_gutter = "#3b4261",
        -- green = "#c3e88d",
        -- green1 = "#4fd6be",
        -- green2 = "#41a6b5",
        -- magenta = "#c099ff",
        -- magenta2 = "#ff007c",
        -- orange = "#ff966c",
        -- purple = "#fca7ea",
        -- red = "#ff757f",
        -- red1 = "#c53b53",
        -- teal = "#4fd6be",
        -- terminal_black = "#444a73",
        -- yellow = "#ffc777",
      },
    },

    groups = {
      link = "iris",
      panel = "surface",
      error = "love",
      hint = "iris",
      info = "foam",
      note = "pine",
      todo = "rose",
      warn = "gold",
      git_add = "leaf",
      git_change = "foam",
      git_delete = "love",
    },

    highlight_groups = {
      -- 1. THE COMMENT FIX
      ["@comment"] = { fg = "#6a8080", italic = true },
      ["Comment"] = { fg = "#6a8080", italic = true },
      ["@lsp.type.comment"] = { fg = "#6a8080" },

      -- 2. KEYWORD DIFFERENTIATION (The "Class vs Export" fix)
      ["@keyword.export"] = { fg = "iris", italic = true },
      ["@keyword.import"] = { fg = "iris", italic = true },
      ["@keyword.storage"] = { fg = "rose" },
      ["@keyword.modifier"] = { fg = "rose", italic = true },
      ["@keyword.conditional"] = { fg = "rose" },

      -- 3. PROPERTY STABILITY (The "Foam" fix)
      ["@variable.member"] = { fg = "foam" },
      ["@property"] = { fg = "foam" },
      ["@field"] = { fg = "foam" },
      ["@variable.parameter"] = { fg = "iris", italic = true },

      -- 4. TYPE DEFINITIONS (Tokyonight Yellow)
      ["@type"] = { fg = "gold", bold = true },
      ["@type.builtin"] = { fg = "gold", bold = true },
      ["@type.definition"] = { fg = "gold", bold = true },
      ["@constant"] = { fg = "pine" },
      ["@boolean"] = { fg = "pine" },
      ["@string"] = { fg = "leaf" },
      ["@function"] = { fg = "iris" },

      -- 5. THE STABILITY ENGINE (LSP Overrides)
      ["@lsp.type.property"] = { fg = "foam" },
      ["@lsp.type.variableMember"] = { fg = "foam" },
      ["@lsp.type.function"] = { link = "@function" },
      ["@lsp.type.method"] = { link = "@function" },
      ["@lsp.type.type"] = { fg = "gold", bold = true },
      ["@lsp.type.class"] = { fg = "gold", bold = true },
      ["@lsp.type.interface"] = { fg = "gold", bold = true },
      ["@lsp.type.parameter"] = { link = "@variable.parameter" },

      -- 6. UI ACCENTS
      Visual = { bg = "#1d3b53", inherit = false },
      CursorLine = { bg = "#021320" },
      LineNr = { fg = "#3b4261" },
      CursorLineNr = { fg = "subtle", bold = true },
      WinSeparator = { fg = "#3b4261", bg = "NONE" },
      CopilotSuggestion = { fg = "#5a6a8a" },
      BlinkCmpGhostText = { fg = "#5a6a8a" },
    },
  },
  config = function(_, opts)
    require("rose-pine").setup(opts)
    vim.cmd("colorscheme rose-pine")
  end,
}
