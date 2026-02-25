-- return {
--   "rose-pine/neovim",
--   name = "rose-pine",
--   opts = {
--     variant = "moon",
--
--     styles = {
--       bold = true,
--       italic = true,
--       transparency = true,
--     },
--   },
--
--   config = function(_, opts)
--     require("rose-pine").setup(opts)
--     vim.cmd("colorscheme rose-pine")
--   end,
-- }
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

        subtle = "#7f9db2", -- lifted slightly
        comment = "#7a9a9a",

        foam = "#5fb3d9",
        gold = "#e0af68",
        iris = "#cbb4ff",

        pine = "#6fb1a0",
        olive = "#8fbf7f",
        sql = "#b5d98c",

        love = "#e06c75",
        keyword = "#4f8fb3",
        operator = "#4a6b80",

        mint = "#7aa2f7",
        rose = "#c678dd",
      },
    },

    highlight_groups = {

      --------------------------------------------------
      -- STRUCTURAL CORE
      --------------------------------------------------

      ["@function"] = { fg = "#c8b6ff" },
      ["@function.definition"] = { fg = "#5fb3d9", bold = true },

      ["@type"] = { fg = "#e0af68" },
      ["@type.definition"] = { fg = "#e0af68", bold = true },

      --------------------------------------------------
      -- FLOW FIELD
      --------------------------------------------------

      ["@function.call"] = { fg = "#cbb4ff" },
      ["@function.method.call"] = { fg = "#cbb4ff" },

      ["@tag"] = { fg = "#c678dd" },
      ["@tag.builtin"] = { fg = "#6fb1a0" },

      ["@_jsx_attribute"] = { fg = "#5fb3d9" },
      ["@tag.attribute"] = { fg = "#5fb3d9" },

      ["@variable.member"] = { fg = "#b794f6" },
      ["@property"] = { fg = "#b794f6" },

      ["@variable.parameter"] = { fg = "#8bb4ff" },

      --------------------------------------------------
      -- DATA SURFACE
      --------------------------------------------------

      ["@variable"] = { fg = "#9bb5c7" }, -- lifted for readability

      ["@variable.builtin"] = { fg = "#5fb3d9", bold = true },
      ["@variable.defaultLibrary"] = { fg = "#5fb3d9", bold = true },

      ["@string"] = { fg = "#8fbf7f" },
      ["@number"] = { fg = "#6fb1a0" },
      ["@boolean"] = { fg = "#6fb1a0" },
      ["@constant"] = { fg = "#6fb1a0" },

      --------------------------------------------------
      -- LANGUAGE CONTROL
      --------------------------------------------------

      ["@keyword"] = { fg = "#5fb3d9" },
      ["@keyword.control"] = { fg = "#5fb3d9" },
      ["@keyword.storage"] = { fg = "#c678dd", bold = true },
      ["@keyword.return"] = { fg = "#5fb3d9" },
      ["@keyword.sql"] = { fg = "#b5d98c", bold = true },

      ["@operator"] = { fg = "#4a6b80" },

      ["@punctuation.bracket"] = { fg = "#6f94a6" },
      ["@punctuation.delimiter"] = { fg = "#6f94a6" },

      --------------------------------------------------
      -- CONTEXT PERIPHERY
      --------------------------------------------------

      ["@comment"] = {
        fg = "#7a9a9a",
        italic = true,
      },

      CursorLine = { bg = "#061e33" },
      Visual = { bg = "#4a7c9e" },
      CursorLineNr = { fg = "#5fb3d9", bold = true },

      Error = { fg = "#e06c75", bold = true },
      Warning = { fg = "#e0af68", bold = true },
    },
  },

  config = function(_, opts)
    require("rose-pine").setup(opts)
    vim.cmd("colorscheme rose-pine")

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function()
        local map = {
          ["@lsp.type.function"] = "@function.call",
          ["@lsp.type.method"] = "@function.method.call",

          ["@lsp.typemod.function.defaultLibrary"] = "@function",

          ["@lsp.type.variable"] = "@variable",
          ["@lsp.type.parameter"] = "@variable.parameter",
          ["@lsp.type.property"] = "@property",

          -- Fix struct object keys - prevent declaration modifier from making them gold
          ["@lsp.typemod.class.declaration"] = "@variable.member",

          ["@lsp.type.class"] = "@type",
          ["@lsp.type.interface"] = "@type",
          ["@lsp.type.enum"] = "@type",
          ["@lsp.type.namespace"] = "@type",

          ["@lsp.type.keyword"] = "@keyword",
        }

        for from, to in pairs(map) do
          vim.api.nvim_set_hl(0, from, { link = to })
        end
      end,
    })
    vim.api.nvim_set_hl(0, "EffectOp", {
      fg = "#e06c75",
      bold = true,
      italic = false,
    })

    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      pattern = { "*.ts", "*.tsx" },
      callback = function()
        vim.fn.matchadd(
          "EffectOp",
          [[\<Effect\.\(gen\|fn\|pipe\|map\|flatMap\|catchTag\|provide\|tap\|all\|run\|try\|fail\|sync\|async\|maybe\|option\)\>]],
          95
        )
      end,
    })
  end,
}
