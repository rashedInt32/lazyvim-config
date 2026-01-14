return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "fang2hou/blink-copilot",
  },
  event = "InsertEnter",
  opts = {
    keymap = {
      ["<C-l>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
      ["<CR>"] = { "fallback" },
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
      trigger = {
        show_on_insert = false,
        show_on_change = false,
        show_on_backspace = false,
      },

      keyword_length = 1,
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
        copilot = { name = "copilot", module = "blink-copilot", score_offset = 120, async = true },

        buffer = { score_offset = 150 },
        path = { score_offset = 140 },
        snippets = {
          score_offset = 100,
          opts = {
            friendly_snippets = false,
            search_paths = { vim.fn.stdpath("config") .. "/snippets" },
          },
        },
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
