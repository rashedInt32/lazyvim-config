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

      -- COMMENTS (important context - visible, not faded)
      ["@comment"] = { fg = "comment", italic = true },
      ["@comment.documentation"] = { fg = "comment", italic = true },

      -- ==========================================
      -- TIER 2: STRUCTURAL (Understanding the code)
      -- ==========================================

      -- Effect operations (special handling for Effect-TS)
      ["@function.builtin"] = { fg = "love" }, -- Effect.gen, Effect.fn, etc.

      -- Type names (types you use, not define)
      ["@type"] = { fg = "gold" },
      ["@type.interface"] = { fg = "gold" },
      ["@type.parameter"] = { fg = "gold" },
      ["@lsp.type.type"] = { fg = "gold" },
      ["@lsp.type.class"] = { fg = "iris" },
      ["@lsp.type.interface"] = { fg = "gold" },
      ["@lsp.type.enum"] = { fg = "iris" },

      -- Namespaces & modules
      ["@module"] = { fg = "iris" },
      ["@namespace"] = { fg = "iris" },
      ["@lsp.type.namespace"] = { fg = "iris" },

      -- Variables & properties (reading data)
      ["@variable.member"] = { fg = "foam" }, -- result.length, user.name
      ["@property"] = { fg = "foam" },
      ["@lsp.type.property"] = { fg = "foam" },
      ["@field"] = { fg = "foam" },

      -- Generic variables (brighter than subtle)
      ["@variable"] = { fg = "subtle" },
      ["@lsp.type.variable"] = { fg = "mint" },

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
      ["@lsp.type.import"] = { fg = "rose" },
      ["@variable.typescript"] = { fg = "rose" },
      ["@include"] = { fg = "rose" },
      ["@include.typescript"] = { fg = "rose" },
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
      ["@lsp.type.parameter"] = { fg = "mint", italic = true },
      ["@lsp.mod.declaration.typescript"] = { fg = "mint", italic = true },
      ["@variable.parameter.typescript"] = { fg = "mint", italic = true },

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
      -- These keep their original colors (not the custom keyword color):
      ["@keyword.function"] = { fg = "pine" }, -- function keyword - keep pine
      ["@keyword.storage"] = { fg = "foam" }, -- class, const, let - keep foam
      ["@keyword.storage.typescript"] = { fg = "foam" }, -- TypeScript class/const/let
      ["@keyword.modifier"] = { fg = "foam" }, -- extends, static, readonly - keep foam
      ["@keyword.modifier.typescript"] = { fg = "foam" }, -- TypeScript extends/static/readonly
      ["@keyword.coroutine"] = { fg = "keyword" }, -- yield (not special, use keyword color)

      -- LSP keyword overrides (prevent LSP from overriding with keyword color)
      ["@lsp.type.keyword"] = { fg = "keyword" },
      ["@lsp.typemod.keyword.declaration.typescript"] = { fg = "foam" }, -- class declarations
      ["@lsp.typemod.keyword.static.typescript"] = { fg = "foam" }, -- static keyword
      ["@lsp.typemod.keyword.async.typescript"] = { fg = "love" }, -- async

      -- SQL strings should use olive, not keyword color
      ["@string.sql"] = { fg = "olive" },
      ["@string.special.sql"] = { fg = "olive" },
      -- SQL keywords inside template literals should use olive too
      ["@keyword.sql"] = { fg = "olive" },

      -- Ensure const vs parameters are different colors
      -- const/let are @keyword.storage (foam), parameters are mint - already different!

      -- Punctuation - barely visible
      ["@punctuation.bracket"] = { fg = "subtle" },
      ["@punctuation.delimiter"] = { fg = "subtle" },
      ["@operator"] = { fg = "operator" },
      ["@operator.typescript"] = { fg = "operator" },
      ["@keyword.operator"] = { fg = "foam" }, -- typeof, instanceof, etc.

      -- Generics syntax (the < > brackets)
      ["@punctuation.special.generic"] = { fg = "subtle" },

      -- ==========================================
      -- LSP SEMANTIC TOKENS (Override to match our colors)
      -- ==========================================

      -- LSP Keywords - ensure they follow our keyword color scheme
      ["@lsp.type.keyword"] = { fg = "keyword" },
      ["@lsp.typemod.keyword.async"] = { fg = "love" },
      ["@lsp.typemod.keyword.declaration"] = { fg = "foam" },
      ["@lsp.typemod.keyword.static"] = { fg = "foam" },
      ["@lsp.typemod.keyword.readonly"] = { fg = "foam" },

      -- LSP Variables - distinguish const vs parameters
      ["@lsp.type.variable"] = { fg = "foam" },
      ["@lsp.typemod.variable.declaration"] = { fg = "foam" },
      ["@lsp.typemod.variable.local"] = { fg = "foam" },
      ["@lsp.typemod.variable.readonly"] = { fg = "foam" },

      -- LSP Parameters
      ["@lsp.type.parameter"] = { fg = "mint", italic = true },
      ["@lsp.typemod.parameter.declaration"] = { fg = "mint", italic = true },

      -- LSP Properties/Members
      ["@lsp.type.property"] = { fg = "foam" },
      ["@lsp.type.member"] = { fg = "foam" },
      ["@lsp.typemod.property.declaration"] = { fg = "iris" },

      -- Object literal keys (messages:, id:)
      ["@property"] = { fg = "iris" },
      ["@property.typescript"] = { fg = "iris" },
      ["@object.property"] = { fg = "iris" },

      -- LSP Functions
      ["@lsp.type.function"] = { fg = "foam" },
      ["@lsp.typemod.function.declaration"] = { fg = "foam", bold = true },
      ["@lsp.type.method"] = { fg = "foam" },
      ["@lsp.typemod.method.declaration"] = { fg = "foam" },

      -- LSP Classes and Types
      ["@lsp.type.class"] = { fg = "iris" },
      ["@lsp.type.interface"] = { fg = "gold" },
      ["@lsp.type.enum"] = { fg = "iris" },
      ["@lsp.type.struct"] = { fg = "iris" },
      ["@lsp.type.typeParameter"] = { fg = "gold" },

      -- LSP Namespaces/Modules
      ["@lsp.type.namespace"] = { fg = "iris" },
      ["@lsp.type.module"] = { fg = "iris" },

      -- LSP Strings (including SQL)
      ["@lsp.type.string"] = { fg = "olive" },
      ["@lsp.typemod.string.injected"] = { fg = "olive" },

      -- LSP Comments
      ["@lsp.type.comment"] = { fg = "comment", italic = true },

      -- LSP Numbers and Constants
      ["@lsp.type.number"] = { fg = "pine" },
      ["@lsp.type.enumMember"] = { fg = "pine" },

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

    -- Highlight Effect-specific operations with love color
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
      pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
      callback = function()
        -- Effect operations
        vim.fn.matchadd(
          "EffectOp",
          "\\<Effect\\.\\(gen\\|fn\\|succeed\\|fail\\|promise\\|sync\\|async\\|pipe\\|catchTag\\|orDie\\|provide\\|map\\|flatMap\\|tap\\|andThen\\|catchAll\\)\\>",
          100
        )
        -- async/await (keep love color, yield uses keyword)
        vim.fn.matchadd("CoroutineKeyword", "\\<async\\>", 100)
        vim.fn.matchadd("CoroutineKeyword", "\\<await\\>", 100)
      end,
    })

    vim.api.nvim_set_hl(0, "EffectOp", { fg = "#ff5189" }) -- love color
    vim.api.nvim_set_hl(0, "CoroutineKeyword", { fg = "#ff5189", italic = true })

    -- Highlight TODO/FIXME in comments
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
      pattern = "*",
      callback = function()
        vim.fn.matchadd("TodoComment", "\\(TODO\\|FIXME\\|NOTE\\|HACK\\|BUG\\|WARNING\\):", 100)
      end,
    })
    vim.api.nvim_set_hl(0, "TodoComment", { fg = "#e0af68", bold = true })
  end,
}
