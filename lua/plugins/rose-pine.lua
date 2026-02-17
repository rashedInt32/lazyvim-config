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

      -- 2. KEYWORD DIFFERENTIATION (Balanced semantic roles)
      ["@keyword.export"] = { fg = "rose", italic = true },
      ["@keyword.import"] = { fg = "rose", italic = true },
      ["@keyword.storage"] = { fg = "pine" },
      ["@keyword.modifier"] = { fg = "rose", italic = true },
      ["@keyword.conditional"] = { fg = "love" },
      ["@keyword.return"] = { fg = "love" },
      ["@keyword.repeat"] = { fg = "love" },
      ["@keyword.coroutine"] = { fg = "rose", italic = true },

      -- 3. PROPERTY STABILITY (The "Foam" fix)
      ["@variable.member"] = { fg = "foam" },
      ["@property"] = { fg = "foam" },
      ["@field"] = { fg = "foam" },
      ["@variable.parameter"] = { fg = "leaf", italic = true },

      -- 4. TYPE DEFINITIONS (Balanced hierarchy)
      ["@type"] = { fg = "gold", bold = true },
      ["@type.builtin"] = { fg = "subtle" },
      ["@type.definition"] = { fg = "gold" },
      ["@type.class"] = { fg = "iris", bold = true },
      ["@type.interface"] = { fg = "foam", bold = true },
      ["@constant"] = { fg = "pine" },
      ["@boolean"] = { fg = "pine" },
      ["@string"] = { fg = "leaf" },
      ["@string.special"] = { fg = "foam" },
      ["@function"] = { fg = "iris" },
      ["@function.method"] = { fg = "gold" },
      ["@function.builtin"] = { fg = "pine" },
      ["@function.macro"] = { fg = "love" },

      -- 5. THE STABILITY ENGINE (LSP Overrides - Balanced)
      ["@lsp.type.property"] = { fg = "foam" },
      ["@lsp.type.variableMember"] = { fg = "foam" },
      ["@lsp.type.function"] = { link = "@function" },
      ["@lsp.type.method"] = { fg = "gold" },
      ["@lsp.type.type"] = { fg = "gold", bold = true },
      ["@lsp.type.class"] = { fg = "iris", bold = true },
      ["@lsp.type.interface"] = { fg = "foam", bold = true },
      ["@lsp.type.parameter"] = { fg = "leaf", italic = true },
      ["@lsp.type.namespace"] = { fg = "iris" },
      ["@lsp.type.enum"] = { fg = "gold" },
      ["@lsp.type.enumMember"] = { fg = "pine" },
      ["@lsp.type.struct"] = { fg = "iris" },
      ["@lsp.type.typeParameter"] = { fg = "rose", italic = true },
      ["@lsp.type.decorator"] = { fg = "love" },
      ["@lsp.type.event"] = { fg = "rose" },
      ["@lsp.type.operator"] = { fg = "subtle" },
      -- LSP Modifiers for additional semantics
      ["@lsp.mod.readonly"] = { fg = "pine", italic = true },
      ["@lsp.mod.static"] = { bold = true },
      ["@lsp.mod.async"] = { fg = "rose", italic = true },
      ["@lsp.mod.abstract"] = { fg = "love", italic = true },
      ["@lsp.mod.deprecated"] = { strikethrough = true },
      ["@lsp.mod.documentation"] = { fg = "foam" },

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
    
    -- Override yield/await/async to use rose color (different from return)
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
      pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.lua" },
      callback = function()
        vim.fn.matchadd("CoroutineKeyword", "\\<yield\\>", 100)
        vim.fn.matchadd("CoroutineKeyword", "\\<await\\>", 100)
        vim.fn.matchadd("CoroutineKeyword", "\\<async\\>", 100)
      end,
    })
    
    -- Define highlight for coroutine keywords using rose color
    vim.api.nvim_set_hl(0, "CoroutineKeyword", { fg = "#ff7eb6", italic = true })
  end,
}
