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
        base = "#011627",
        surface = "#011f35",
        overlay = "#0b2942",
        muted = "#637777",
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

    groups = {
      border = "overlay",
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

      -- 3. UI ACCENTS & BORDER FIX
      CursorLine = { bg = "#021320" },
      LineNr = { fg = "#3b4261" },
      CursorLineNr = { fg = "subtle", bold = true },

      -- THE BORDER FIX: This makes split lines visible
      -- WinSeparator: The lines between windows
      -- NormalNC: Colors for Non-Current (inactive) windows
      WinSeparator = { fg = "#1a3a5e", bg = "NONE" },
      StatusLine = { fg = "subtle", bg = "#011f35" },
      StatusLineNC = { fg = "muted", bg = "#011627" },

      -- Better Floating Windows
      NormalFloat = { bg = "surface" },
      FloatBorder = { fg = "overlay", bg = "surface" },
    },
  },
  config = function(_, opts)
    require("rose-pine").setup(opts)
    vim.cmd("colorscheme rose-pine")
  end,
}
