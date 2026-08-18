return {
  "stevearc/conform.nvim",

  opts = {
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = false,

    formatters_by_ft = {
      javascript = { "smart_format" },
      typescript = { "smart_format" },
      javascriptreact = { "smart_format" },
      typescriptreact = { "smart_format" },

      blade = { "blade-formatter" },
      prisma = { "prisma" },
      lua = { "stylua" },
      sql = { "sleek" },
    },

    formatters = {
      stylua = {
        command = "stylua",
        stdin = true,
        -- `filter` is not a job-formatter key (conform only reads it under
        -- lsp_format opts), so the old version of this never skipped anything.
        -- `condition` is the real hook, and conform calls it as (self, ctx).
        condition = function(_, ctx)
          return not ctx.filename:match("autocmds%.lua$")
        end,
      },

      sleek = {
        command = "/Users/rashed/.cargo/bin/sleek",
        args = { "--indent-spaces=2", "--lines-between-queries=3" },
        stdin = true,
      },

      prisma = {
        command = "npx",
        args = { "prisma", "format", "--schema", "$FILENAME" },
        stdin = false,
      },

      ["blade-formatter"] = {
        command = "blade-formatter",
        args = { "--stdin", "--indent-size", "4", "--wrap-attributes" },
        stdin = true,
      },

      smart_format = {
        command = function(self, ctx)
          local dirname = vim.fn.fnamemodify(ctx.filename, ":h")
          local config_files = {
            ".prettierrc",
            ".prettierrc.json",
            ".prettierrc.yml",
            ".prettierrc.yaml",
            ".prettierrc.js",
            ".prettierrc.mjs",
            ".prettierrc.cjs",
            "prettier.config.js",
            "prettier.config.mjs",
            "prettier.config.cjs",
          }

          local has_config = false
          for _, file in ipairs(config_files) do
            local path = vim.fn.findfile(file, dirname .. ";")
            if path ~= "" then
              has_config = true
              break
            end
          end

          if not has_config then
            local pkg_path = vim.fn.findfile("package.json", dirname .. ";")
            if pkg_path ~= "" then
              local content = vim.fn.readfile(pkg_path)
              local ok, json = pcall(vim.json.decode, table.concat(content, "\n"))
              if ok and json and json.prettier then
                has_config = true
              end
            end
          end

          return has_config and "prettier" or "biome"
        end,
        args = function(self, ctx)
          local cmd = self.command(self, ctx)
          if cmd == "prettier" then
            return { "--stdin-filepath", ctx.filename }
          else
            return { "format", "--indent-style", "space", "--indent-width", "2", "--stdin-file-path", ctx.filename }
          end
        end,
        stdin = true,
        -- conform calls condition as (self, ctx). Declaring it as (ctx) bound
        -- `self` to the first argument, so ctx.filename was nil, the pcall
        -- failed, and this 200KB guard silently passed everything through.
        condition = function(_, ctx)
          local max_size = 200 * 1024
          local stats = (vim.uv or vim.loop).fs_stat(ctx.filename)
          return not (stats and stats.size > max_size)
        end,
      },

      prettier = {
        command = "prettier",
        args = { "--stdin-filepath", "$FILENAME" },
        stdin = true,
      },

      biome = {
        command = "biome",
        args = { "format", "--indent-style", "space", "--indent-width", "2", "--stdin-file-path", "$FILENAME" },
        stdin = true,
      },
    },
  },
}
