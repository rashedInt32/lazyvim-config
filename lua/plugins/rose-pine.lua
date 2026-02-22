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

      ["@variable.member"] = { fg = "#8f6fd1" },
      ["@property"] = { fg = "#8f6fd1" },

      ["@variable.parameter"] = { fg = "#8bb4ff" },

      --------------------------------------------------
      -- DATA SURFACE
      --------------------------------------------------

      ["@variable"] = { fg = "#7f9db2" }, -- lifted for readability

      ["@variable.builtin"] = { fg = "#5fb3d9", bold = true },
      ["@variable.defaultLibrary"] = { fg = "#5fb3d9", bold = true },

      ["@string"] = { fg = "#8fbf7f" },
      ["@number"] = { fg = "#6fb1a0" },
      ["@boolean"] = { fg = "#6fb1a0" },
      ["@constant"] = { fg = "#6fb1a0" },

      --------------------------------------------------
      -- LANGUAGE CONTROL
      --------------------------------------------------

      ["@keyword"] = { fg = "#4f8fb3" },
      ["@keyword.control"] = { fg = "#4f8fb3" },
      ["@keyword.storage"] = { fg = "#4f8fb3" },
      ["@keyword.return"] = { fg = "#4f8fb3" },
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

      CursorLine = { bg = "#021320" },
      Visual = { bg = "#234d6b" },
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
  end,
}
