return {
  {
    "christopher-francisco/tmux-status.nvim",
    lazy = true,
    opts = {
      colors = {
        session = { fg = "#005f00" },
      },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "christopher-francisco/tmux-status.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        --theme = "night-owl", -- let it adapt to colorscheme (or set manually)
        theme = "powerline_custom",
        --theme = "tokyonight", -- let it adapt to colorscheme (or set manually)
        section_separators = { left = " ", right = " " },
        component_separators = { left = "", right = "" },
        globalstatus = true,
        icons_enabled = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = { "filename" },
        lualine_x = {
          {
            "filetype",
            icon_only = true,
            colored = true,
            icon = { align = "right" },
          },
        },
        lualine_z = {
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
            colored = true,
            diff_color = {
              added = { fg = "#22da6e" },
              modified = { fg = "#c7925b" },
              removed = { fg = "#ef5350" },
            },
          },
          {
            "diagnostics",
            --sources = { "nvim_lsp" },
            sections = { "error", "warn", "info", "hint" },
            symbols = {
              error = " ",
              warn = " ",
              info = " ",
              hint = " ",
            },

            diagnostics_color = {
              error = { fg = "#ef5350" }, -- red
              warn = { fg = "#c7925b" }, -- yellow-orange
              info = { fg = "#82aaff" }, -- blue
              hint = { fg = "#22da6e" }, -- green
            },
            update_in_insert = false,
            always_visible = true,
          },
          {
            function()
              local str = require("tmux-status").tmux_session()
              return str:gsub("%%#.-#", "") -- remove %#hlgroup#
              --return require("tmux-status").tmux_session()
            end,
            cond = function()
              return require("tmux-status").show()
            end,
            padding = { left = 2, right = 2 },
            color = { fg = "#005f00" }, -- Here's the match
          },
        },
      },
    },
  },
}
