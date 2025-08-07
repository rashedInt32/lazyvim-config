return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      javascript = { "prettierd", "prettier", "biome" },
      typescript = { "prettierd", "prettier", "biome" },
      javascriptreact = { "prettierd", "prettier", "biome" },
      typescriptreact = { "prettierd", "prettier", "biome" },
      prisma = { "prisma" },
      -- fallback
      ["_"] = { "trim_whitespace" },
    },
    formatters = {
      prisma = {
        command = "npx",
        args = { "prisma", "format", "--schema", "$FILENAME" },
        stdin = false, -- Required for npx prisma format
      },
    },
  },
}
