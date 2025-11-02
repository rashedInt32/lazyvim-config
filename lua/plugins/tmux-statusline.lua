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
        --theme = "powerline_custom",
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
              added = { fg = "#117a3b" },
              modified = { fg = "#8c5f3d" },
              removed = { fg = "#a72627" },
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
              error = { fg = "#a72627" }, -- red
              warn = { fg = "#8c5f3d" }, -- yellow-orange
              info = { fg = "#375f9f" }, -- blue
              hint = { fg = "#117a3b" }, -- green
            },
            update_in_insert = false,
            always_visible = false,
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
