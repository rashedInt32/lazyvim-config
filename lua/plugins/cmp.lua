return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "fang2hou/blink-copilot",
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
          end
        end,
        "fallback",
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
      accept = {
        auto_brackets = {
          enabled = false,
        },
      },
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
      default = { "lsp", "copilot", "buffer", "path", "snippets" },
      providers = {
        lsp = { score_offset = 250 },
        copilot = { name = "copilot", module = "blink-copilot", score_offset = 200, async = true },
        buffer = { score_offset = 150 },
        path = { score_offset = 140 },
        snippets = { score_offset = 120, module = "blink.cmp.sources.snippets" },
      },
    },
  },

  opts_extend = { "sources.default" },
  config = function(_, opts)
    if opts.sources and opts.sources.compat then
      opts.sources.compat = nil
    end
    require("blink.cmp").setup(opts)
  end,
}
