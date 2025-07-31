return {
  {
    "christopher-francisco/tmux-status.nvim",
    lazy = true,
    opts = {},
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "christopher-francisco/tmux-status.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    init = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          vim.api.nvim_set_hl(0, "LualineTmux", {
            fg = "#82aaff", -- Night Owl blue
            bg = "#011627", -- Night Owl background
            bold = true,
          })
        end,
      })
    end,
    opts = {
      options = {
        --theme = "night-owl", -- let it adapt to colorscheme (or set manually)
        theme = "tokyonight", -- let it adapt to colorscheme (or set manually)
        section_separators = { left = "", right = "" },
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
          {
            function()
              return require("tmux-status").tmux_session()
            end,
            cond = function()
              return require("tmux-status").show()
            end,
            color = { fg = "#82aaff", bg = "#011627", gui = "bold" },
            padding = { left = 3, right = 2 },
          },
        },
        lualine_z = {
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
            colored = true,
            diff_color = {
              added = { fg = "#22da6e", bg = "#011627" }, -- Night Owl green
              modified = { fg = "#c7925b", bg = "#011627" }, -- Night Owl yellow-orange
              removed = { fg = "#ef5350", bg = "#011627" }, -- Night Owl red
            },
          },
          {
            "diagnostics",
            sources = { "nvim_lsp" },
            sections = { "error", "warn", "info", "hint" },
            symbols = {
              error = " ",
              warn = " ",
              info = " ",
              hint = " ",
            },
            diagnostics_color = {
              error = { fg = "#ef5350", bg = "#011627" }, -- red
              warn = { fg = "#c7925b", bg = "#011627" }, -- yellow-orange
              info = { fg = "#82aaff", bg = "#011627" }, -- blue
              hint = { fg = "#22da6e", bg = "#011627" }, -- green
            },
            update_in_insert = false,
            always_visible = true,
          },
        },
      },
    },
  },
}
