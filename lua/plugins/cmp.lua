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
        lsp = { score_offset = 150 },
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot",
          score_offset = 120,
          async = true,
        },
        path = { score_offset = 110 },
        buffer = { score_offset = 80 },
        snippets = { score_offset = 50, module = "blink.cmp.sources.snippets" },
      },
    },
  },

  opts_extend = { "sources.default" },
  config = function(_, opts)
    if opts.sources and opts.sources.compat then
      opts.sources.compat = nil
    end
    -- Ensure blink-cmp-copilot is loaded
    require("blink-cmp-copilot")
    -- Setup Blink
    require("blink.cmp").setup(opts)

    -- Custom keymap for <C-F> to accept Copilot suggestion
    vim.keymap.set("i", "<C-f>", function()
      local copilot = require("copilot.suggestion")
      if copilot.is_visible() then
        copilot.accept()
      else
        -- Fallback to move cursor right
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Right>", true, false, true), "n", false)
      end
    end, { silent = true, desc = "Accept Copilot suggestion or move right" })
  end,
}
