return {
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = false,
  priority = 1000,

  opts = {
    variant = "main",

    styles = {
      bold = true,
      italic = true,
      transparency = true,
    },

    palette = {
      main = {
        base = "#011627",
        surface = "#0b2233",
        overlay = "#102a3f",

        subtle = "#7f9db2",
        comment = "#7a9a9a",

        foam = "#5fb3d9",
        gold = "#e0af68",
        iris = "#cbb4ff",

        pine = "#6fb1a0",
        olive = "#8fbf7f",
        sql = "#b5d98c",

        love = "#e06c75",
        keyword = "#5fb3d9",
        operator = "#56738a",

        mint = "#7aa2f7",
        rose = "#c678dd",
      },
    },

    highlight_groups = {
      --------------------------------------------------
      -- STRUCTURAL SCAFFOLDING — quiet slate
      -- Keywords/operators/punctuation recede so verbs and data lead.
      --------------------------------------------------

      ["@keyword"] = { fg = "#5fb3d9" },
      ["@keyword.function"] = { fg = "#5fb3d9" },
      ["@keyword.type"] = { fg = "#5fb3d9" },
      ["@keyword.modifier"] = { fg = "#5fb3d9" },
      ["@keyword.conditional"] = { fg = "#5fb3d9" },
      ["@keyword.repeat"] = { fg = "#5fb3d9" },
      ["@keyword.import"] = { fg = "#6fb1a0" },
      ["@keyword.export"] = { fg = "#6fb1a0" },
      ["@keyword.return"] = { fg = "#5fb3d9" },
      ["@keyword.operator"] = { fg = "#5fb3d9" },
      ["@keyword.coroutine"] = { fg = "#5fb3d9" },
      ["@keyword.exception"] = { fg = "#5fb3d9" },
      ["@keyword.control"] = { fg = "#5fb3d9" },
      ["@keyword.storage"] = { fg = "#5fb3d9" },
      ["@keyword.sql"] = { fg = "#b5d98c", bold = true },

      ["@operator"] = { fg = "#4a6b80" },
      ["@punctuation.bracket"] = { fg = "#6f94a6" },
      ["@punctuation.delimiter"] = { fg = "#6f94a6" },

      --------------------------------------------------
      -- DEFINITIONS — most prominent. Bold reserved for declarations.
      --------------------------------------------------

      ["@function"] = { fg = "#cbb4ff" },
      ["@function.call"] = { fg = "#cbb4ff" },
      ["@function.method"] = { fg = "#cbb4ff" },
      ["@function.method.call"] = { fg = "#cbb4ff" },
      ["@function.builtin"] = { fg = "#cbb4ff" },
      ["@function.definition"] = { fg = "#c8b6ff", bold = true },

      ["@type"] = { fg = "#e0af68" },
      ["@type.builtin"] = { fg = "#e0af68" },
      ["@type.definition"] = { fg = "#e0af68", bold = true },

      -- Namespaces are containers, not types — calmer mauve.
      ["@module"] = { fg = "#a890c4" },

      --------------------------------------------------
      -- DATA / VALUES
      --------------------------------------------------

      ["@string"] = { fg = "#8fbf7f" },
      ["@string.regexp"] = { fg = "#e0af68" },
      ["@string.escape"] = { fg = "#6fb1a0" },
      ["@string.special"] = { fg = "#6fb1a0" },

      ["@number"] = { fg = "#6fb1a0" },
      ["@number.float"] = { fg = "#6fb1a0" },
      ["@boolean"] = { fg = "#6fb1a0" },
      ["@constant"] = { fg = "#6fb1a0" },
      ["@constant.builtin"] = { fg = "#6fb1a0" },
      ["@constant.macro"] = { fg = "#6fb1a0" },

      --------------------------------------------------
      -- IDENTIFIERS
      --------------------------------------------------

      ["@variable"] = { fg = "#9bb5c7" },
      ["@variable.builtin"] = { fg = "#5fb3d9", bold = true },
      ["@variable.parameter"] = { fg = "#8bb4ff" },
      ["@variable.member"] = { fg = "#b794f6" },
      ["@property"] = { fg = "#b794f6" },

      --------------------------------------------------
      -- JSX / MARKUP
      --------------------------------------------------

      ["@tag"] = { fg = "#c678dd" },
      ["@tag.builtin"] = { fg = "#6fb1a0" },
      ["@tag.attribute"] = { fg = "#5fb3d9" },
      ["@_jsx_attribute"] = { fg = "#5fb3d9" },

      --------------------------------------------------
      -- COMMENTS
      --------------------------------------------------

      ["@comment"] = { fg = "#7a9a9a", italic = true },
      ["@comment.documentation"] = { fg = "#7a9a9a", italic = true },

      --------------------------------------------------
      -- UI
      --------------------------------------------------

      CursorLine = { bg = "#061e33" },
      Visual = { bg = "#4a7c9e" },
      CursorLineNr = { fg = "#5fb3d9", bold = true },

      Error = { fg = "#e06c75", bold = true },
      Warning = { fg = "#e0af68", bold = true },

      DiagnosticError = { fg = "#e06c75", bold = true },
      DiagnosticWarn = { fg = "#e0af68", bold = true },
      DiagnosticInfo = { fg = "#5fb3d9", bold = true },
      DiagnosticHint = { fg = "#8fbf7f", bold = true },

      --------------------------------------------------
      -- CUSTOM
      --------------------------------------------------

      -- Effect.gen is a program-opener — the "do-notation" of Effect.
      -- Warm rose-pink: cool-on-cool blends, warm advances against the
      -- deep teal base, so the marker leaps off the page.
      EffectGen = { fg = "#e09cb0", bold = true },
    },
  },

  config = function(_, opts)
    require("rose-pine").setup(opts)
    vim.cmd("colorscheme rose-pine")

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function()
        local map = {
          -- Functions
          ["@lsp.type.function"] = "@function",
          ["@lsp.typemod.function.declaration"] = "@function.definition",
          ["@lsp.typemod.function.definition"] = "@function.definition",
          ["@lsp.typemod.function.defaultLibrary"] = "@function",

          -- Methods: declarations bold, calls (incl. on built-in containers) lavender.
          ["@lsp.type.method"] = "@function.method.call",
          ["@lsp.typemod.method.declaration"] = "@function.definition",
          ["@lsp.typemod.method.definition"] = "@function.definition",
          ["@lsp.typemod.method.defaultLibrary"] = "@function.method.call",

          -- Parameters and properties
          ["@lsp.type.parameter"] = "@variable.parameter",
          ["@lsp.type.property"] = "@property",

          -- Types: references calm, declarations bright gold bold.
          ["@lsp.type.class"] = "@type",
          ["@lsp.type.interface"] = "@type",
          ["@lsp.type.enum"] = "@type",
          ["@lsp.type.type"] = "@type",
          ["@lsp.type.typeParameter"] = "@type",
          ["@lsp.typemod.class.declaration"] = "@variable.member",
          ["@lsp.typemod.class.definition"] = "@variable.member",
          ["@lsp.typemod.interface.declaration"] = "@type.definition",
          ["@lsp.typemod.interface.definition"] = "@type.definition",
          ["@lsp.typemod.enum.declaration"] = "@type.definition",
          ["@lsp.typemod.enum.definition"] = "@type.definition",
          ["@lsp.typemod.type.declaration"] = "@type.definition",
          ["@lsp.typemod.type.definition"] = "@type.definition",

          -- The Effect-key move: namespaces are NOT types.
          ["@lsp.type.namespace"] = "@module",

          -- Enum members read as constants.
          ["@lsp.type.enumMember"] = "@constant",

          -- Decorators
          ["@lsp.type.decorator"] = "@function",
        }

        for from, to in pairs(map) do
          vim.api.nvim_set_hl(0, from, { link = to })
        end
      end,
    })

    -- Mark Effect.gen as special — it opens an Effect program scope,
    -- visually distinct from regular Effect.<method> operations.
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = { "*.ts", "*.tsx" },
      callback = function()
        vim.fn.matchadd("EffectGen", [[\<Effect\.\(gen\|fn\)\>]], 95)
      end,
    })
  end,
}
