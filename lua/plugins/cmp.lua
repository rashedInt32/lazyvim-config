return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "zbirenbaum/copilot.lua", -- Copilot
  },
  opts = {
    keymap = {
      ["<Tab>"] = { "snippet_forward", "select_and_accept", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
      ["<CR>"] = { "fallback" },
    },
    default = { "path", "lsp", "copilot", "buffer", "snippets", "emmet" },
    providers = {
      path = { name = "path", score_offset = 110 },
      emmet = { name = "emmet", score_offset = 60 },
      lsp = { name = "lsp", score_offset = 90 },
      snippets = { name = "snippets", score_offset = 50 },
      buffer = { name = "buffer", score_offset = 80 },
    },
    appearance = {
      nerd_font_variant = "mono",
    },
    signature = {
      enabled = true,
      window = {
        border = "rounded",
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        max_height = 8,
        max_width = 80,
      },
    },
    completion = {
      documentation = {
        auto_show = true,
        window = {
          border = "rounded",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          max_height = 15,
          max_width = 100,
        },
      },
    },
    sources = {
      default = { "path", "lsp", "buffer", "snippets" },
    },
  },
  opts_extend = { "sources.default" },
  config = function(_, opts)
    if opts.sources and opts.sources.compat then
      opts.sources.compat = nil
    end
    -- Setup Blink
    require("blink.cmp").setup(opts)

    -- Setup Copilot
    require("copilot").setup({
      suggestion = { enabled = true, auto_trigger = true },
      panel = { enabled = false },
    })

    -- Copilot + Blink <C-F>
    local copilot = require("copilot.suggestion")
    vim.keymap.set("i", "<C-F>", function()
      if copilot.is_visible() then
        copilot.accept()
      else
        local blink = require("blink.cmp.keymap")
        blink.accept() -- fallback to Blink accept
      end
    end, { silent = true, desc = "Copilot or Blink accept" })
  end,
}
