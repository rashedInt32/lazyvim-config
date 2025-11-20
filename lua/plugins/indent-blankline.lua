return {
  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
      },
      scope = {
        enabled = false, -- turn off bold indent lines
      },
    },
    config = function(_, opts)
      local ibl = require("ibl")
      ibl.setup(opts)

      -- Optional: subtle color for indent lines
      vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3b3b3b", nocombine = true })
    end,
  },

  -- Rainbow delimiters
  {
    "HiPhish/rainbow-delimiters.nvim",
    config = function()
      -- Define colors (you can tweak these to match your theme)
      vim.g.rainbow_delimiters = {
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
          "RainbowDelimiterPink",
          "RainbowDelimiterLime",
          "RainbowDelimiterTeal",
          "RainbowDelimiterCoral",
          "RainbowDelimiterLavender",
        },
      }

      vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#e06c75" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#e5c07b" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#61afef" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#d19a66" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#98c379" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#c678dd" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#56b6c2" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterPink", { fg = "#ff79c6" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterLime", { fg = "#50fa7b" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterTeal", { fg = "#1abc9c" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterCoral", { fg = "#ff6b6b" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterLavender", { fg = "#bd93f9" })
    end,
  },
}
