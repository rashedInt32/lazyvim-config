return {
  "stevearc/conform.nvim",

  opts = {
    default_format_opts = {
      inherit = true,
    },
    format_on_save = false,

    formatters_by_ft = {
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },

      blade = { "blade-formatter" },
      prisma = { "prisma" },
      lua = { "stylua" },
      sql = { "sleek" },

      --["_"] = { "trim_whitespace" },
    },

    formatters = {
      stylua = {
        command = "stylua",
        stdin = true,
        filter = function(buf)
          local filename = vim.api.nvim_buf_get_name(buf)
          return not filename:match("autocmds%.lua$")
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

      prettier = {
        command = "prettier",
        args = { "--stdin-filepath", "$FILENAME" },
        stdin = true,
        inherit = true,
        condition = function(ctx)
          local max_size = 200 * 1024
          local ok, stats = pcall(vim.loop.fs_stat, ctx.filename)
          if ok and stats and stats.size > max_size then
            return false
          end
          return true
        end,
      },
    },
  },
}
