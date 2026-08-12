return {
  {
    "dgox16/oldworld.nvim",
    lazy = true,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "dgox16/oldworld.nvim",
    },
    config = function()
      local colors = require("oldworld.palette")

      local function config_lualine(colors)
        local modecolor = {
          n = colors.red,
          i = colors.cyan,
          v = colors.purple,
          ["\22"] = colors.purple,
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
          t = colors.red,
        }

        local theme = {
          normal = {
            a = { fg = colors.bg_dark, bg = colors.blue },
            b = { fg = colors.blue, bg = colors.fg },
            c = { fg = colors.fg, bg = "#01111d" },
            z = { fg = colors.fg, bg = "#01111d" },
          },
          insert = {
            a = { fg = colors.bg_dark, bg = colors.orange },
            b = { fg = colors.blue, bg = colors.fg },
            c = { fg = colors.fg, bg = "#01111d" },
            z = { fg = colors.fg, bg = "#01111d" },
          },
          visual = {
            a = { fg = colors.bg_dark, bg = colors.green },
            b = { fg = colors.blue, bg = colors.fg },
            c = { fg = colors.fg, bg = "#01111d" },
            z = { fg = colors.fg, bg = "#01111d" },
          },
          replace = {
            a = { fg = colors.bg_dark, bg = colors.green },
            b = { fg = colors.blue, bg = colors.fg },
            c = { fg = colors.fg, bg = "#01111d" },
            z = { fg = colors.fg, bg = "#01111d" },
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
            -- mode(1) so the multi-char keys (no, ic, Rv, ...) can actually match.
            return { bg = modecolor[vim.fn.mode(1)] or colors.blue, fg = colors.bg_dark, gui = "bold" }
          end,
          separator = { left = "", right = "" },
        }

        local macro = {
          function()
            -- Extract "@x" from "recording @x"; noice can report other modes.
            local mode = require("noice").api.status.mode.get()
            local reg = mode and mode:match("@%w")
            return reg and (" " .. reg) or ""
          end,
          cond = function()
            return require("noice").api.status.mode.has()
          end,
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

        -- Every Claude agent on the machine, not just this nvim's sidekick.
        -- Requires lazily inside the functions so lualine can set up before
        -- claude-sessions.nvim has loaded (lazy.nvim loads it on require).
        local claude = {
          function()
            return require("claude-sessions").status()
          end,
          cond = function()
            return require("claude-sessions").has_sessions()
          end,
          color = { bg = "#01111d" },
          padding = 1,
        }

        require("lualine").setup({
          options = {
            disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
            icons_enabled = true,
            theme = theme,
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            globalstatus = true,
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
            },
            lualine_x = { claude },
            lualine_y = { macro },
            lualine_z = {
              diff,
              space,
              location,
              space,
              dia,
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
