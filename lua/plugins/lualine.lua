return {
  {
    "dgox16/oldworld.nvim",
    lazy = true,
  },

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
      "nvim-tree/nvim-web-devicons",
      "dgox16/oldworld.nvim",
      "christopher-francisco/tmux-status.nvim",
    },
    config = function()
      local colors = require("oldworld.palette")

      local function config_lualine(colors)
        local modecolor = {
          n = colors.red,
          i = colors.cyan,
          v = colors.purple,
          [""] = colors.purple,
          V = colors.red,
          c = colors.yellow,
          no = colors.red,
          s = colors.yellow,
          S = colors.yellow,
          ic = colors.yellow,
          R = colors.green,
          Rv = colors.purple,
          cv = colors.red,
          ce = colors.red,
          r = colors.cyan,
          rm = colors.cyan,
          ["r?"] = colors.cyan,
          ["!"] = colors.red,
          t = colors.bright_red,
        }

        local theme = {
          normal = {
            a = { fg = colors.bg_dark, bg = colors.blue },
            b = { fg = colors.blue, bg = colors.white },
            c = { fg = colors.white, bg = "#01111d" },
            z = { fg = colors.white, bg = "#01111d" },
          },
          insert = {
            a = { fg = colors.bg_dark, bg = colors.orange },
            b = { fg = colors.blue, bg = colors.white },
            c = { fg = colors.white, bg = "#01111d" },
            z = { fg = colors.white, bg = "#01111d" },
          },
          visual = {
            a = { fg = colors.bg_dark, bg = colors.green },
            b = { fg = colors.blue, bg = colors.white },
            c = { fg = colors.white, bg = "#01111d" },
            z = { fg = colors.white, bg = "#01111d" },
          },
          replace = {
            a = { fg = colors.bg_dark, bg = colors.green },
            b = { fg = colors.blue, bg = colors.white },
            c = { fg = colors.white, bg = "#01111d" },
            z = { fg = colors.white, bg = "#01111d" },
          },
        }

        local space = {
          function()
            return " "
          end,
          color = { bg = "#01111d", fg = colors.blue },
        }

        local filename = {
          "filename",
          color = { bg = colors.blue, fg = colors.bg, gui = "bold" },
          separator = { left = "", right = "" },
        }

        local filetype = {
          "filetype",
          icon_only = true,
          colored = true,

          color = { fg = colors.blue, gui = "italic,bold" },
          icon = { align = "right" },
        }

        local branch = {
          "branch",
          icon = " ",
          color = { bg = colors.green, fg = colors.bg, gui = "bold" },
          separator = { left = "", right = "" },
        }

        local location = {
          "location",
          color = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
          separator = { left = "", right = "" },
        }

        local diff = {
          "diff",
          color = { bg = colors.gray2, fg = colors.bg, gui = "bold" },
          separator = { left = "", right = "" },
          symbols = { added = " ", modified = " ", removed = " " },
          --symbols = { added = " ", modified = " ", removed = " " },
          colored = true,

          diff_color = {
            added = { fg = colors.green },
            modified = { fg = colors.yellow },
            removed = { fg = colors.red },
          },
        }

        local modes = {
          "mode",
          color = function()
            local mode_color = modecolor
            return { bg = mode_color[vim.fn.mode()], fg = colors.bg_dark, gui = "bold" }
          end,
          separator = { left = "", right = "" },
        }

        local macro = {
          function()
            local mode = require("noice").api.status.mode.get()
            -- Extract "@x" from "recording @x"
            return mode and (" " .. mode:match("@%w"))
          end,
          cond = require("noice").api.status.mode.has,
          color = { fg = colors.red, bg = "#01111d", gui = "italic,bold" },
        }

        local dia = {
          "diagnostics",
          sources = { "nvim_diagnostic" },
          symbols = { error = " ", warn = " ", info = " ", hint = " " },

          diagnostics_color = {
            error = { fg = colors.red },
            warn = { fg = colors.yellow },
            info = { fg = colors.purple },
            hint = { fg = colors.cyan },
          },
          color = { bg = colors.gray2, fg = colors.blue, gui = "bold" },
          separator = { left = "", right = "" },
          always_visible = true,
        }

        local tmux_session = {
          function()
            local str = require("tmux-status").tmux_session()
            return str:gsub("%%#.-#", "")
          end,
          cond = function()
            return require("tmux-status").show()
          end,
          color = { fg = "#005f00", bg = "#01111d" },
          separator = { left = "", right = "" },
        }

        require("lualine").setup({
          options = {
            disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
            icons_enabled = true,
            theme = theme,
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            ignore_focus = {},
            --always_divide_middle = true,
            globalstatus = true,
            component_padding = 0,
          },

          sections = {
            lualine_a = {
              modes,
            },
            lualine_b = {
              space,
            },
            lualine_c = {
              branch,
              space,
              filename,
              --filetype,
            },
            lualine_x = {},
            lualine_y = { macro },
            lualine_z = {
              diff,
              space,
              location,
              space,
              dia,
              --tmux_session,
            },
          },

          inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
          },
        })
      end

      config_lualine(colors)
      vim.o.laststatus = vim.g.lualine_laststatus
    end,
  },
}
