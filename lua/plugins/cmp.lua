return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "giuxtaposition/blink-cmp-copilot",
  },
  event = "InsertEnter",
  opts = {
    keymap = {
      ["<Tab>"] = { "snippet_forward", "select_and_accept", "fallback" },
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
      default = { "copilot", "path", "lsp", "buffer", "snippets" }, -- No Copilot or Emmet
      providers = {
        path = { score_offset = 110 },
        lsp = { score_offset = 90 },
        snippets = { score_offset = 50 },
        buffer = { score_offset = 80 },
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot",
          score_offset = 120,
          async = true,
        },
      },
    },
  },

  opts_extend = { "sources.default" },
  config = function(_, opts)
    if opts.sources and opts.sources.compat then
      opts.sources.compat = nil
    end
    -- Setup Blink
    require("blink.cmp").setup(opts)

    -- Optional: Custom keymap for <C-F> to ensure it only handles Copilot
    vim.keymap.set("i", "<C-F>", function()
      local copilot = require("copilot.suggestion")
      if copilot.is_visible() then
        copilot.accept()
      else
        -- Fallback to default <C-F> behavior (e.g., move cursor right)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-F>", true, false, true), "n", false)
      end
    end, { silent = true, desc = "Accept Copilot suggestion" })
  end,
}
