-- ~/.config/nvim/lua/autocmd.lua

-- Close floating terminals safely
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  pattern = "*",
  callback = function()
    local status_ok, toggleterm = pcall(require, "toggleterm.terminal")
    if not status_ok then
      return
    end

    -- iterate through all terminals
    for _, term in pairs(toggleterm.get_all()) do
      if term.direction == "float" and vim.api.nvim_win_is_valid(term.window) then
        term:close()
      end
    end
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkLoaded",
  callback = function()
    vim.api.nvim_del_keymap("i", "<C-F>")
  end,
})

vim.api.nvim_create_user_command("TestLualine", function()
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
      [""] = colors.yellow,
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

      color = { bg = colors.gray2, fg = colors.blue, gui = "italic,bold" },
      separator = { left = "", right = "" },
    }

    local branch = {
      "branch",
      icon = "",
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

    local function getLspName()
      local bufnr = vim.api.nvim_get_current_buf()
      local buf_ft = vim.bo.filetype

      local client_names = {}

      ----------------------------------------------------------------------
      -- LSP clients
      ----------------------------------------------------------------------
      local buf_clients = vim.lsp.get_clients({ bufnr = bufnr })

      for _, client in ipairs(buf_clients) do
        table.insert(client_names, client.name)
      end

      ----------------------------------------------------------------------
      -- nvim-lint
      ----------------------------------------------------------------------
      local lint_ok, lint = pcall(require, "lint")
      if lint_ok and lint.linters_by_ft then
        local linters = lint.linters_by_ft[buf_ft]
        if type(linters) == "table" then
          for _, l in ipairs(linters) do
            table.insert(client_names, l)
          end
        elseif type(linters) == "string" then
          table.insert(client_names, linters)
        end
      end

      ----------------------------------------------------------------------
      -- conform.nvim
      ----------------------------------------------------------------------
      local conform_ok, conform = pcall(require, "conform")
      if conform_ok then
        local formatters = table.concat(conform.list_formatters_for_buffer(), " ")
        if conform_ok then
          for formatter in formatters:gmatch("%w+") do
            if formatter then
              table.insert(client_names, formatter)
            end
          end
        end
      end

      ----------------------------------------------------------------------
      -- Si no hay nada, mostrar "No tools"
      ----------------------------------------------------------------------
      if #client_names == 0 then
        return "  No tools"
      end

      ----------------------------------------------------------------------
      -- Eliminar duplicados
      ----------------------------------------------------------------------
      local uniq, seen = {}, {}
      for _, name in ipairs(client_names) do
        if not seen[name] then
          table.insert(uniq, name)
          seen[name] = true
        end
      end

      return "  " .. table.concat(uniq, ", ")
    end

    local macro = {
      require("noice").api.status.mode.get,
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
      separator = { left = "" },
    }

    local lsp = {
      function()
        return getLspName()
      end,
      separator = { left = "", right = "" },
      color = { bg = colors.purple, fg = colors.bg, gui = "italic,bold" },
    }

    require("lualine").setup({
      options = {
        disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
        icons_enabled = true,
        theme = theme,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        ignore_focus = {},
        always_divide_middle = true,
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
          --filetype,
        },
        lualine_x = {
          space,
        },
        lualine_y = { macro, space },
        lualine_z = {
          location,
          space,
          diff,
          space,
          dia,
          lsp,
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
  print("✓ Test lualine config loaded")
end, {})

vim.api.nvim_create_user_command("ResetLualine", function()
  require("lazy").reload({ plugins = { "lualine.nvim" } })
  print("✓ Reset to original lualine config")
end, {})
