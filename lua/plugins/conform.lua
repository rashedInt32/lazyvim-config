return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      javascript = { "prettier" },
      --typescript = { "prettier" },
      javascriptreact = { "prettier" },
      --typescriptreact = { "prettier" },
      blade = { "blade-formatter" },
      prisma = { "prisma" },
      lua = { "stylua" },
      fish = {},
      sql = { "sleek" },
      ["_"] = { "trim_whitespace" },
    },
    formatters = {
      stylua = {
        command = "stylua",
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
        stdin = false, -- Required for npx prisma format
      },
      ["blade-formatter"] = {
        command = "blade-formatter",
        args = { "--stdin", "--indent-size", "4", "--wrap-attributes" },
        stdin = true,
      },
    },
  },
}
