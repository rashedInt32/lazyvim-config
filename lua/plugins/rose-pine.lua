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
        muted = "#637777", -- Night Owl Slate Comments
        subtle = "#82aaff",
        rose = "#ff7eb6",
        pine = "#7fdbca",
        foam = "#7dcfff",
        iris = "#c792ea",
        leaf = "#c3e88d",
        love = "#ff5189",
        gold = "#ecc48d",
      },
    },

    -- We removed 'border = "overlay"' from here to let Rose Pine decide
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
      ["@comment"] = { fg = "#637777", italic = true },
      ["Comment"] = { fg = "#637777", italic = true },
      ["@lsp.type.comment"] = { fg = "#637777" },

      -- 2. SYNTAX REFINEMENTS
      Visual = { bg = "#1d3b53", inherit = false },
      ["@keyword.modifier"] = { fg = "rose", italic = true },
      ["@function"] = { fg = "iris" },
      ["@type"] = { fg = "gold" },
      ["@type.definition"] = { fg = "gold", bold = true },
      ["@string"] = { fg = "leaf" },
      ["@variable.member"] = { fg = "foam" },
      ["@property"] = { fg = "foam" },
      ["@constant"] = { fg = "pine" },
      ["@boolean"] = { fg = "pine" },

      -- 3. UI ACCENTS
      CursorLine = { bg = "#021320" },
      LineNr = { fg = "#3b4261" },
      CursorLineNr = { fg = "subtle", bold = true },

      -- 4. BORDER FIX (VERTICAL SPLITS)
      -- Using Rose Pine's internal 'muted' or 'highlight_med' for splits
      WinSeparator = { fg = "#3b4261", bg = "NONE" },

      -- REMOVED: NormalFloat and FloatBorder overrides to return to defaults
    },
  },
  config = function(_, opts)
    require("rose-pine").setup(opts)
    vim.cmd("colorscheme rose-pine")
  end,
}
