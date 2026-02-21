return {
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = false,
  priority = 1000,

  opts = {
    variant = "main",

    disable_background = true, -- set true if you want terminal bg to show through
    disable_float_background = false,

    styles = {
      bold = true,
      italic = true,
      transparency = false,
    },

    -- Respect official Rose Pine main palette as base
    -- Only override what actually improves readability for your style
    palette = {
      main = {
        -- Official-ish darks (much better than #011627)
        base = "#191724",
        surface = "#1f1d2e",
        overlay = "#26233a",

        -- Official midtones
        muted = "#6e6a86",
        subtle = "#908caa",
        text = "#e0def4",

        -- Your semantic colors – tuned to feel more cohesive
        rose = "#ebbcba", -- soft pink-coral (good for love/error)
        pine = "#31748f", -- official pine (used for numbers/constants)
        foam = "#9ccfd8", -- soft cyan (better than #5fb3d9 for eyes)
        gold = "#f6c177", -- warmer gold/yellow
        iris = "#c4a7e7", -- softer purple (official-ish)
        love = "#eb6f92",

        -- Custom semantic overrides (your additions + tweaks)
        keyword = "#7aa2f7", -- blue-cyan (TokyoNight-like, very readable)
        operator = "#7aa2f7", -- same as keyword → consistent
        sql = "#9ece6a", -- soft green for SQL
        olive = "#9ece6a", -- strings (was too yellow-green before)
      },
    },

    highlight_groups = {
      -- ────────────────────────────────────────────────
      -- STRUCTURAL / DEFINITIONS
      -- ────────────────────────────────────────────────
      ["@function.definition"] = { fg = "foam", bold = true },
      ["@function.method.definition"] = { fg = "foam", bold = true },
      ["@type.definition"] = { fg = "gold", bold = true },
      ["@class.definition"] = { fg = "gold", bold = true },

      -- ────────────────────────────────────────────────
      -- EXECUTION FLOW / CALLS
      -- ────────────────────────────────────────────────
      ["@function.call"] = { fg = "iris" },
      ["@variable.member"] = { fg = "iris" },
      ["@property"] = { fg = "iris" },
      ["@field"] = { fg = "iris" },

      -- ────────────────────────────────────────────────
      -- DATA / VALUES
      -- ────────────────────────────────────────────────
      ["@variable.builtin"] = { fg = "foam" },
      ["@string"] = { fg = "olive" },
      ["@number"] = { fg = "pine" },
      ["@boolean"] = { fg = "pine" },
      ["@constant"] = { fg = "pine" },

      -- ────────────────────────────────────────────────
      -- LANGUAGE / CONTROL
      -- ────────────────────────────────────────────────
      ["@keyword"] = { fg = "keyword" },
      ["@keyword.storage"] = { fg = "keyword" },
      ["@keyword.control"] = { fg = "keyword" },
      ["@keyword.return"] = { fg = "keyword" },
      ["@keyword.coroutine"] = { fg = "keyword" },
      ["@keyword.sql"] = { fg = "sql", bold = true },

      -- ────────────────────────────────────────────────
      -- UI / CONTEXT
      -- ────────────────────────────────────────────────
      ["@comment"] = { fg = "muted", italic = true },

      CursorLine = { bg = "#1f1d2e" }, -- matches surface
      Visual = { bg = "#2a283e" },
      CursorLineNr = { fg = "foam", bold = true },

      Error = { fg = "love", bold = true },
      Warning = { fg = "gold", bold = true },

      -- Make punctuation / structural noise much quieter
      ["@punctuation.bracket"] = { fg = "#403d52" }, -- very dim purple-gray (official muted-ish)
      ["@punctuation.delimiter"] = { fg = "#403d52" },
      ["@operator"] = { fg = "#7aa2f7", bold = false }, -- keep color but remove any extra boldness if present

      -- Normal variables & params → softer, less emphasis
      ["@variable"] = { fg = "#9aa0b9" }, -- slightly dimmer than subtle
      ["@variable.parameter"] = { fg = "#a0b0d0", italic = true }, -- subtle italic helps

      -- Make Effect namespace / calls pop more (without being ugly red)
      ["@function.method.call"] = { fg = "#c4a7e7" }, -- iris/purple (already there, good)
      -- Special boost for Effect.* specifically
      EffectOp = { fg = "#c099ff", bold = true }, -- slightly brighter lavender

      -- Better union / type separator visibility without noise
      ["@type"] = { fg = "#f6c177" }, -- gold (keep)
      ["@type.builtin"] = { fg = "#f6c177", bold = false }, -- slightly less aggressive for primitives
    },
  },

  config = function(_, opts)
    require("rose-pine").setup(opts)
    vim.cmd("colorscheme rose-pine")

    -- LSP semantic tokens linking (your "GOD TIER SEMANTIC LOCK")
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function()
        local map = {
          ["@lsp.type.function"] = "@function.definition",
          ["@lsp.type.method"] = "@function.method.call", -- was .call, feels better for usage
          ["@lsp.type.variable"] = "@variable",
          ["@lsp.type.parameter"] = "@variable.parameter",
          ["@lsp.type.property"] = "@property",
          ["@lsp.type.class"] = "@type",
          ["@lsp.type.interface"] = "@type",
          ["@lsp.type.enum"] = "@type",
          ["@lsp.type.namespace"] = "@type",
          ["@lsp.type.keyword"] = "@keyword",
          ["@lsp.typemod.variable.readonly"] = "@variable",
          ["@lsp.typemod.property.readonly"] = "@property",
        }

        -- Base LSP fallback
        vim.api.nvim_set_hl(0, "@lsp", { link = "@variable" })

        for from, to in pairs(map) do
          vim.api.nvim_set_hl(0, from, { link = to })
        end
      end,
    })

    -- Effect.* operator highlighting (improved contrast & readability)
    vim.api.nvim_set_hl(0, "EffectOp", {
      fg = "#bb9af7", -- softer lavender-purple (stands out but not red)
      bold = true,
      italic = false,
    })

    vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
      pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
      callback = function()
        -- More Effect methods + better priority
        vim.fn.matchadd(
          "EffectOp",
          [[\<Effect\.\(gen\|fn\|pipe\|map\|flatMap\|catchTag\|provide\|tap\|all\|run\|try\|fail\|sync\|async\|maybe\|option\)\>]],
          95
        )
      end,
    })
  end,
}
