return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "giuxtaposition/blink-cmp-copilot",
  },
  event = "InsertEnter",
  opts = {
    keymap = {
      ["<Tab>"] = { "select_and_accept", "fallback" },
      ["<S-Tab>"] = { "fallback" },
      ["<CR>"] = { "fallback" },
      ["<C-f>"] = {
        function(cmp)
          local copilot = require("copilot.suggestion")
          if copilot.is_visible() then
            copilot.accept()
            return true
          end
          return false
        end,
        "fallback"
      },
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
      default = { "copilot", "snippets", "lsp", "buffer", "path" },
      providers = {
        copilot = { name = "copilot", module = "blink-cmp-copilot", score_offset = 250, async = true },
        snippets = { score_offset = 200, module = "blink.cmp.sources.snippets" },
        lsp = { score_offset = 150 },
        buffer = { score_offset = 100 },
        path = { score_offset = 50 },
      },
    },
  },

  opts_extend = { "sources.default" },
  config = function(_, opts)
    if opts.sources and opts.sources.compat then
      opts.sources.compat = nil
    end
    require("blink-cmp-copilot")
    require("blink.cmp").setup(opts)


  end,
}
