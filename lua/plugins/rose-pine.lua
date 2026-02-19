return {
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = false,
  priority = 1000,

  opts = {
    variant = "main",
    dark_variant = "main",
    styles = { bold = true, italic = true, transparency = false },

    palette = {
      main = {
        base = "#011627", -- Night Owl Background
        surface = "#011f35",
        overlay = "#0b2942",
        muted = "#6a8080", -- Comments / documentation
        subtle = "#637777", -- Keywords, punctuation (fade away)
        rose = "#ff7eb6", -- Imports, module paths
        pine = "#7fdbca", -- Constants, booleans, numbers
        foam = "#7dcfff", -- Functions, methods, definitions (THE STAR)
        iris = "#c792ea", -- Classes, namespaces, Effect types
        love = "#ff5189", -- Effect operations, special keywords
        gold = "#e0af68", -- Type names, interfaces, generics
        mint = "#b4befe", -- Parameters (italicized)
        olive = "#addb67", -- Strings, SQL literals
        keyword = "#3e8fb0", -- Keywords (const, return, if, etc.)
        operator = "#5f7e97", -- Night Owl operator color
        comment = "#8a9b9b", -- Brighter gray comment color
      },
    },

    highlight_groups = {
      -- ==========================================
      -- TIER 1: CRITICAL (What you scan for)
      -- ==========================================

      -- Function & method DEFINITIONS (bold - these matter most)
      ["@function"] = { fg = "foam" },
      ["@function.definition"] = { fg = "foam", bold = true },
      ["@function.method"] = { fg = "foam" },
      ["@function.method.definition"] = { fg = "foam", bold = true },
      ["@function.call"] = { fg = "foam" },

      -- Class & Type DEFINITIONS
      ["@type.definition"] = { fg = "gold", bold = true },
      ["@class.definition"] = { fg = "iris", bold = true },

      -- SQL STRINGS (the business logic)
      ["@string"] = { fg = "olive" },
      ["@string.documentation"] = { fg = "olive", italic = true },
      ["@string.special"] = { fg = "olive" }, -- Template literals
      ["@string.sql"] = { fg = "olive" },
      ["@string.special.sql"] = { fg = "olive" },

      -- COMMENTS (important context - visible, not faded)
      ["@comment"] = { fg = "comment", italic = true },
      ["@comment.documentation"] = { fg = "comment", italic = true },

      -- SQL injection content fallback
      ["@injection.content"] = { link = "@string" },

      -- ==========================================
      -- TIER 2: STRUCTURAL (Understanding the code)
      -- ==========================================

      -- Effect operations (special handling for Effect-TS)
      ["@function.builtin"] = { fg = "love" }, -- Effect.gen, Effect.fn, etc.

      -- Type names (types you use, not define)
      ["@type"] = { fg = "gold" },
      ["@type.interface"] = { fg = "gold" },
      ["@type.parameter"] = { fg = "gold" },

      -- Namespaces & modules
      ["@module"] = { fg = "iris" },
      ["@namespace"] = { fg = "iris" },

      -- Variables & properties (reading data)
      ["@variable.member"] = { fg = "foam" }, -- result.length, user.name
      ["@property"] = { fg = "iris" }, -- object keys: message:, id:
      ["@field"] = { fg = "foam" },

      -- Generic variables (brighter than subtle)
      ["@variable"] = { fg = "subtle" },

      -- Constants & data
      ["@constant"] = { fg = "pine" },
      ["@constant.builtin"] = { fg = "pine" },
      ["@number"] = { fg = "pine" },
      ["@boolean"] = { fg = "pine" },

      -- ==========================================
      -- TIER 3: IMPORTS (Context for where things come from)
      -- ==========================================

      -- Import statements (rose for visibility)
      ["@variable.import"] = { fg = "rose" },
      ["@include"] = { fg = "rose" },
      ["@import"] = { fg = "rose" },

      -- Import sources
      ["@string.special.url"] = { fg = "rose" },
      ["@namespace.import"] = { fg = "rose" },

      -- ==========================================
      -- TIER 4: PARAMETERS (Editorial style)
      -- ==========================================

      -- Function parameters (italic for distinction)
      ["@variable.parameter"] = { fg = "mint", italic = true },
      ["@parameter"] = { fg = "mint", italic = true },

      -- Template literal parameters ${...}
      ["@punctuation.special"] = { fg = "foam" },

      -- ==========================================
      -- TIER 5: NOISE (Fade into background)
      -- ==========================================

      -- Keywords - basic keywords use custom color, others keep original
      ["@keyword"] = { fg = "keyword" },
      ["@keyword.conditional"] = { fg = "keyword" }, -- if, else
      ["@keyword.control"] = { fg = "keyword" }, -- return, yield
      ["@keyword.return"] = { fg = "keyword" },
      ["@keyword.import"] = { fg = "keyword" }, -- import
      ["@keyword.export"] = { fg = "keyword" }, -- export
      ["@keyword.function"] = { fg = "pine" }, -- function keyword - keep pine
      ["@keyword.storage"] = { fg = "foam" }, -- class, const, let - keep foam
      ["@keyword.modifier"] = { fg = "foam" }, -- extends, static - keep foam
      ["@keyword.coroutine"] = { fg = "keyword" }, -- yield (not special, use keyword color)
      ["@keyword.sql"] = { fg = "olive" }, -- SQL keywords inside template literals

      -- Punctuation - barely visible
      ["@punctuation.bracket"] = { fg = "subtle" },
      ["@punctuation.delimiter"] = { fg = "subtle" },
      ["@operator"] = { fg = "operator" },
      ["@keyword.operator"] = { fg = "foam" }, -- typeof, instanceof, etc.

      -- Generics syntax (the < > brackets)
      ["@punctuation.special.generic"] = { fg = "subtle" },

      -- ==========================================
      -- UI ELEMENTS
      -- ==========================================

      Visual = { bg = "#1b2e3f", inherit = false },
      CursorLine = { bg = "#081d2f" },
      LineNr = { fg = "#3b4261" },
      CursorLineNr = { fg = "foam", bold = true },

      -- TODO/FIXME comments (bold for attention)
      Todo = { fg = "gold", bold = true },
      Fixme = { fg = "love", bold = true },
      Warning = { fg = "gold", bold = true },
      Error = { fg = "love", bold = true },
    },
  },

  config = function(_, opts)
    require("rose-pine").setup(opts)
    vim.cmd("colorscheme rose-pine")

    -- ==========================================
    -- LSP SEMANTIC TOKEN HARMONIZATION
    -- ==========================================
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function()
        local links = {
          -- Base LSP types
          ["@lsp.type.class"] = "@type",
          ["@lsp.type.interface"] = "@type",
          ["@lsp.type.function"] = "@function",
          ["@lsp.type.method"] = "@function",
          ["@lsp.type.parameter"] = "@variable.parameter",
          ["@lsp.type.property"] = "@property",
          ["@lsp.type.namespace"] = "@namespace",
          ["@lsp.type.module"] = "@module",
          ["@lsp.type.string"] = "@string",
          ["@lsp.type.number"] = "@number",
          ["@lsp.type.boolean"] = "@boolean",
          ["@lsp.type.comment"] = "@comment",
          ["@lsp.type.keyword"] = "@keyword",
          ["@lsp.type.enum"] = "@type",
          ["@lsp.type.enumMember"] = "@constant",

          -- LSP Parameters (ensure mint italic)
          ["@lsp.type.parameter"] = "@variable.parameter",
          ["@lsp.typemod.parameter.declaration"] = "@variable.parameter",

          -- LSP Properties - object literal keys should be iris (purple)
          ["@lsp.type.property"] = "@property",
          ["@lsp.type.member"] = "@property",
          ["@lsp.typemod.property.declaration"] = "@property",

          -- LSP Variables
          ["@lsp.type.variable"] = "@variable",
          ["@lsp.typemod.variable.declaration"] = "@variable",
          ["@lsp.typemod.variable.local"] = "@variable",
          ["@lsp.typemod.variable.readonly"] = "@keyword.storage",

          -- TypeScript-specific semantic tokens
          ["@lsp.type.variable.typescript"] = "@variable",
          ["@lsp.typemod.variable.declaration.typescript"] = "@keyword.storage",
          ["@lsp.typemod.variable.readonly.typescript"] = "@keyword.storage",
          ["@lsp.typemod.variable.local.typescript"] = "@variable",
          ["@lsp.mod.declaration.typescript"] = "@keyword.storage",
          ["@lsp.mod.readonly.typescript"] = "@keyword.storage",
          ["@lsp.typemod.keyword.declaration.typescript"] = "@keyword.storage",
          ["@lsp.typemod.keyword.static.typescript"] = "@keyword.storage",
          ["@lsp.typemod.keyword.async.typescript"] = "@keyword",
        }

        for from, to in pairs(links) do
          vim.api.nvim_set_hl(0, from, { link = to })
        end
      end,
    })

    -- ==========================================
    -- EFFECT-TS & SPECIAL HIGHLIGHTING
    -- ==========================================
    vim.api.nvim_set_hl(0, "EffectOp", { fg = "#ff5189", bold = true })
    vim.api.nvim_set_hl(0, "CoroutineKeyword", { fg = "#ff5189", italic = true })
    vim.api.nvim_set_hl(0, "ReadonlyKeyword", { fg = "#3e8fb0" })
    vim.api.nvim_set_hl(0, "TodoComment", { fg = "#e0af68", bold = true })

    -- Re-apply EffectOp highlighting after LSP attaches (to ensure it takes precedence)
    vim.api.nvim_create_autocmd("LspAttach", {
      pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
      callback = function()
        vim.fn.matchadd(
          "EffectOp",
          [[\<Effect\.\(gen\|fn\|succeed\|fail\|promise\|sync\|async\|pipe\|catchTag\|orDie\|provide\|map\|flatMap\|tap\|andThen\|catchAll\)\>]],
          100
        )
      end,
    })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
      pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
      callback = function()
        -- Effect operations (high priority to override LSP)
        vim.fn.matchadd(
          "EffectOp",
          [[\<Effect\.\(gen\|fn\|succeed\|fail\|promise\|sync\|async\|pipe\|catchTag\|orDie\|provide\|map\|flatMap\|tap\|andThen\|catchAll\)\>]],
          100
        )
        -- async/await (high priority to override LSP)
        vim.fn.matchadd("CoroutineKeyword", [[\<async\>]], 100)
        vim.fn.matchadd("CoroutineKeyword", [[\<await\>]], 100)
        -- readonly keyword
        vim.fn.matchadd("ReadonlyKeyword", [[\<readonly\>]], 101)
        -- TODO/FIXME in comments
        vim.fn.matchadd("TodoComment", [[\(TODO\|FIXME\|NOTE\|HACK\|BUG\|WARNING\):]], 101)
      end,
    })
  end,
}
