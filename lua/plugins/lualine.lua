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
      local bar_bg = "#01111d"

      -- oldworld's purple (#aca1cf) and cyan (#85b5ba) are too muted for the
      -- mode segment; the cyan also collides with the branch green, and the
      -- blue with the lavender claude pill.
      local mode_purple = "#bb9af7"
      local mode_cyan = "#74c7ec"
      local mode_blue = "#82aaff"

      local modecolor = {
        n = colors.red,
        i = mode_cyan,
        v = mode_purple,
        ["\22"] = mode_purple,
        V = colors.red,
        c = colors.yellow,
        no = colors.red,
        s = colors.yellow,
        S = colors.yellow,
        ic = colors.yellow,
        R = colors.green,
        Rv = mode_purple,
        cv = colors.red,
        ce = colors.red,
        r = mode_cyan,
        rm = mode_cyan,
        ["r?"] = mode_cyan,
        ["!"] = colors.red,
        t = mode_blue,
      }

      -- Only section a varies by mode; b/c/z are shared.
      local theme = {}
      for mode, accent in pairs({
        normal = colors.blue,
        insert = colors.orange,
        visual = colors.green,
        replace = colors.green,
      }) do
        theme[mode] = {
          a = { fg = colors.bg_dark, bg = accent },
          b = { fg = colors.blue, bg = colors.fg },
          c = { fg = colors.fg, bg = bar_bg },
          z = { fg = colors.fg, bg = bar_bg },
        }
      end

      local space = {
        function()
          return " "
        end,
        color = { bg = bar_bg, fg = colors.blue },
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
          -- Unlisted long modes (nt, niI, Rc, ...) fall back to their first char.
          local m = vim.fn.mode(1)
          local bg = modecolor[m] or modecolor[m:sub(1, 1)] or mode_blue
          return { bg = bg, fg = colors.bg_dark, gui = "bold" }
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
        color = { fg = colors.red, bg = bar_bg, gui = "italic,bold" },
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
        color = { bg = bar_bg },
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
      vim.o.laststatus = vim.g.lualine_laststatus
    end,
  },
}
