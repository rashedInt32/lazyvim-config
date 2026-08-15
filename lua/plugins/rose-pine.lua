local c = {
  -- backgrounds
  base = "#011627",
  surface = "#0b2233",
  overlay = "#102a3f",
  cursorline_bg = "#061e33",
  visual_bg = "#2d5a7e",

  -- neutrals
  subtle = "#7f9db2",
  comment = "#7a9a9a",

  -- rose-pine accents
  foam = "#5fb3d9", -- variable.builtin, info, CursorLineNr, tag.attribute
  gold = "#e0af68", -- types, regex, warn
  iris = "#cbb4ff", -- functions
  iris_bright = "#c8b6ff", -- function.definition
  pine = "#6fb1a0", -- numbers, constants, imports, escapes
  olive = "#8fbf7f", -- strings, hint
  sql = "#b5d98c",
  love = "#e06c75", -- errors
  rose = "#c678dd", -- tags
  mint = "#7aa2f7",

  -- structural scaffolding
  keyword = "#3e80a8",
  operator = "#4a6b80",
  operator_subtle = "#56738a",
  punctuation = "#6f94a6",
  module = "#a890c4",

  -- identifiers
  variable = "#9bb5c7",
  parameter = "#8bb4ff",
  member = "#b794f6",

  -- custom
  effect_gen = "#e09cb0",
}

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
        base = c.base,
        surface = c.surface,
        overlay = c.overlay,

        subtle = c.subtle,
        comment = c.comment,

        foam = c.foam,
        gold = c.gold,
        iris = c.iris,

        pine = c.pine,
        olive = c.olive,
        sql = c.sql,

        love = c.love,
        keyword = c.keyword,
        operator = c.operator_subtle,

        mint = c.mint,
        rose = c.rose,
      },
    },

    highlight_groups = {
      --------------------------------------------------
      -- STRUCTURAL SCAFFOLDING — quiet slate
      -- Keywords/operators/punctuation recede so verbs and data lead.
      --------------------------------------------------

      ["@keyword"] = { fg = c.keyword },
      ["@keyword.function"] = { fg = c.keyword },
      ["@keyword.type"] = { fg = c.keyword },
      ["@keyword.modifier"] = { fg = c.keyword },
      ["@keyword.conditional"] = { fg = c.keyword },
      ["@keyword.repeat"] = { fg = c.keyword },
      ["@keyword.import"] = { fg = c.pine },
      ["@keyword.export"] = { fg = c.pine },
      ["@keyword.return"] = { fg = c.keyword },
      ["@keyword.operator"] = { fg = c.keyword },
      ["@keyword.coroutine"] = { fg = c.keyword },
      ["@keyword.exception"] = { fg = c.keyword },
      ["@keyword.control"] = { fg = c.keyword },
      ["@keyword.storage"] = { fg = c.keyword },
      ["@keyword.sql"] = { fg = c.sql, bold = true },

      ["@operator"] = { fg = c.operator },
      ["@punctuation.bracket"] = { fg = c.punctuation },
      ["@punctuation.delimiter"] = { fg = c.punctuation },

      --------------------------------------------------
      -- DEFINITIONS — most prominent. Bold reserved for declarations.
      --------------------------------------------------

      ["@function"] = { fg = c.iris },
      ["@function.call"] = { fg = c.iris },
      ["@function.method"] = { fg = c.iris },
      ["@function.method.call"] = { fg = c.iris },
      ["@function.builtin"] = { fg = c.iris },
      ["@function.definition"] = { fg = c.iris_bright, bold = true },

      ["@type"] = { fg = c.gold },
      ["@type.builtin"] = { fg = c.gold },
      ["@type.definition"] = { fg = c.gold, bold = true },

      -- Namespaces are containers, not types — calmer mauve.
      ["@module"] = { fg = c.module },

      --------------------------------------------------
      -- DATA / VALUES
      --------------------------------------------------

      ["@string"] = { fg = c.olive },
      ["@string.regexp"] = { fg = c.gold },
      ["@string.escape"] = { fg = c.pine },
      ["@string.special"] = { fg = c.pine },

      ["@number"] = { fg = c.pine },
      ["@number.float"] = { fg = c.pine },
      ["@boolean"] = { fg = c.pine },
      ["@constant"] = { fg = c.pine },
      ["@constant.builtin"] = { fg = c.pine },
      ["@constant.macro"] = { fg = c.pine },

      --------------------------------------------------
      -- IDENTIFIERS
      --------------------------------------------------

      ["@variable"] = { fg = c.variable },
      ["@variable.builtin"] = { fg = c.foam, bold = true },
      ["@variable.parameter"] = { fg = c.parameter },
      ["@variable.member"] = { fg = c.member },
      ["@property"] = { fg = c.member },

      --------------------------------------------------
      -- JSX / MARKUP
      --------------------------------------------------

      ["@tag"] = { fg = c.rose },
      ["@tag.builtin"] = { fg = c.pine },
      ["@tag.attribute"] = { fg = c.foam },
      ["@_jsx_attribute"] = { fg = c.foam },

      --------------------------------------------------
      -- COMMENTS
      --------------------------------------------------

      ["@comment"] = { fg = c.comment, italic = true },
      ["@comment.documentation"] = { fg = c.comment, italic = true },

      --------------------------------------------------
      -- UI
      --------------------------------------------------

      CursorLine = { bg = c.cursorline_bg },
      -- inherit = false: rose-pine's default Visual has blend = 15, which
      -- would dilute this bg to near-invisibility against the base.
      Visual = { bg = c.visual_bg, inherit = false },
      CursorLineNr = { fg = c.foam, bold = true },

      Error = { fg = c.love, bold = true },
      Warning = { fg = c.gold, bold = true },

      DiagnosticError = { fg = c.love, bold = true },
      DiagnosticWarn = { fg = c.gold, bold = true },
      DiagnosticInfo = { fg = c.foam, bold = true },
      DiagnosticHint = { fg = c.olive, bold = true },

      --------------------------------------------------
      -- CUSTOM
      --------------------------------------------------

      -- Effect.gen is a program-opener — the "do-notation" of Effect.
      -- Warm rose-pink: cool-on-cool blends, warm advances against the
      -- deep teal base, so the marker leaps off the page.
      EffectGen = { fg = c.effect_gen, bold = true },
    },
  },

  config = function(_, opts)
    -- No `colorscheme` call here. LazyVim applies it (see config/lazy.lua), and
    -- doing it in both places fires every ColorScheme autocmd twice.
    require("rose-pine").setup(opts)

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
        -- matchadd appends unconditionally and matches are window-local, so an
        -- unguarded hook stacks a duplicate pattern on every buffer entry and
        -- each copy is re-evaluated on redraw. Scan rather than cache a flag:
        -- the list stays at one entry, and it self-corrects if matches are cleared.
        for _, m in ipairs(vim.fn.getmatches()) do
          if m.group == "EffectGen" then
            return
          end
        end
        vim.fn.matchadd("EffectGen", [[\<Effect\.\(gen\|fn\)\>]], 95)
      end,
    })
  end,
}
