return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      javascript = { "prettierd", "prettier", "biome" },
      typescript = { "prettierd", "prettier", "biome" },
      javascriptreact = { "prettierd", "prettier", "biome" },
      typescriptreact = { "prettierd", "prettier", "biome" },
      blade = { "blade-formatter" }, -- Add this line
      prisma = { "prisma" },
      lua = { "stylua" },
      fish = {}, -- Disable Fish formatting
      sql = { "sleek" },
      -- fallback
      ["_"] = { "trim_whitespace" },
    },
    formatters = {
      sleek = {
        command = "sleek",
        args = "--indent-spaces=2 --lines-between-queries=3",
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
