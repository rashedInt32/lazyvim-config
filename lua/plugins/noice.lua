return {
  {
    "folke/noice.nvim",
    priority = 1000,
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      cmdline = {
        view = "cmdline",
      },
      presets = { command_palette = false },
      lsp = {
        signature = {
          enabled = false,
        },
        hover = {
          enabled = true,
        },
      },
    },
    config = function(_, opts)
      require("noice").setup(opts)

      -- Override LSP hover to strip diagnostics from type hover
      vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
        if not (result and result.contents) then
          return
        end

        local function filter_diagnostics(contents)
          local new_contents = {}

          local function is_diagnostic_line(line)
            return line:match("TS%d+") -- e.g., TS6133
              or line:match("diagnostic")
              or line:match("unused")
              or line:match("declared but never used")
              or line:match("is declared but its value is never read")
          end

          if type(contents) == "string" then
            for line in contents:gmatch("[^\r\n]+") do
              if not is_diagnostic_line(line) then
                table.insert(new_contents, line)
              end
            end
          elseif type(contents) == "table" then
            for _, entry in ipairs(contents) do
              if type(entry) == "string" then
                for line in entry:gmatch("[^\r\n]+") do
                  if not is_diagnostic_line(line) then
                    table.insert(new_contents, line)
                  end
                end
              elseif type(entry) == "table" and entry.language and entry.value then
                local lines = {}
                for line in entry.value:gmatch("[^\r\n]+") do
                  if not is_diagnostic_line(line) then
                    table.insert(lines, line)
                  end
                end
                table.insert(new_contents, { language = entry.language, value = table.concat(lines, "\n") })
              end
            end
          end

          return new_contents
        end

        result.contents = filter_diagnostics(result.contents)
        return vim.lsp.handlers.hover(err, result, ctx, config)
      end
    end,
  },
}
