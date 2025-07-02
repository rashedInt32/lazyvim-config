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
      "nvim-tree/nvim-web-devicons", -- Add this dependency explicitly
    },
    init = function()
      -- Set custom highlight before lualine loads
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          vim.api.nvim_set_hl(0, "LualineTmux", {
            fg = "#7aa2f7", -- Tokyonight blue
            bg = "#1a1b26", -- Tokyonight background
            bold = true,
          })
        end,
      })
    end,
    opts = {
      options = {
        theme = "tokyonight",
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
            icon_only = true, -- Show only the icon
            colored = true, -- Enable colored icons
            icon = { align = "right" }, -- Align the icon
          },
          {
            function()
              return require("tmux-status").tmux_session()
            end,
            cond = function()
              return require("tmux-status").show()
            end,
            color = { fg = "#7aa2f7", bg = "#1a1b26", gui = "bold" },
            padding = { left = 3, right = 2 },
          },
        },
        lualine_z = {
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
            colored = true,
            diff_color = {
              added = { fg = "#9ece6a", bg = "#1a1b26" }, -- greenish
              modified = { fg = "#e0af68", bg = "#1a1b26" }, -- yellow-orange
              removed = { fg = "#f7768e", bg = "#1a1b26" }, -- redish
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
              error = { fg = "#f7768e", bg = "#1a1b26" },
              warn = { fg = "#e0af68", bg = "#1a1b26" },
              info = { fg = "#7aa2f7", bg = "#1a1b26" },
              hint = { fg = "#9ece6a", bg = "#1a1b26" },
            },
            update_in_insert = false,
            always_visible = true,
          },
        },
      },
    },
  },
}
