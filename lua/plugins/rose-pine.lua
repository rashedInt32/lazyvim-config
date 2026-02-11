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

      -- 2. KEYWORD DIFFERENTIATION (The "Class vs Export" fix)
      ["@keyword.export"] = { fg = "iris", italic = true }, -- 'export', 'import', 'from'
      ["@keyword.function"] = { fg = "iris", italic = true }, -- 'function'
      ["@keyword.repeat"] = { fg = "iris" }, -- 'for', 'while'
      ["@keyword.return"] = { fg = "iris" }, -- 'return'

      ["@keyword.storage"] = { fg = "rose" }, -- 'class', 'const', 'let'
      ["@keyword.modifier"] = { fg = "rose", italic = true }, -- 'readonly', 'static'
      ["@keyword.conditional"] = { fg = "rose" }, -- 'if', 'else'

      -- 3. SYNTAX & PROPERTY STABILITY (The "Foam" fix)
      ["@variable.member"] = { fg = "foam" },
      ["@property"] = { fg = "foam" },
      ["@field"] = { fg = "foam" },
      ["@variable.parameter"] = { fg = "iris", italic = true },

      -- 4. TYPE DEFINITIONS (The "Gold" section)
      ["@type"] = { fg = "gold" },
      ["@type.definition"] = { fg = "gold", bold = true },
      ["@constant"] = { fg = "pine" },
      ["@boolean"] = { fg = "pine" },
      ["@string"] = { fg = "leaf" },
      ["@function"] = { fg = "iris" },

      -- 5. THE "TOKYONIGHT" STABILITY ENGINE (LSP Overrides)
      -- This stops the 2-second delay/color shift by forcing LSP to match TS
      ["@lsp.type.property"] = { link = "@property" },
      ["@lsp.type.variableMember"] = { link = "@variable.member" },
      ["@lsp.type.function"] = { link = "@function" },
      ["@lsp.type.method"] = { link = "@function" },
      ["@lsp.type.type"] = { link = "@type" },
      ["@lsp.type.class"] = { link = "@type" },
      ["@lsp.type.interface"] = { link = "@type" },
      ["@lsp.type.parameter"] = { link = "@variable.parameter" },

      -- 6. UI ACCENTS
      Visual = { bg = "#1d3b53", inherit = false },
      CursorLine = { bg = "#021320" },
      LineNr = { fg = "#3b4261" },
      CursorLineNr = { fg = "subtle", bold = true },
      WinSeparator = { fg = "#3b4261", bg = "NONE" },
    },
  },
  config = function(_, opts)
    require("rose-pine").setup(opts)
    --vim.cmd("colorscheme rose-pine")
  end,
}
