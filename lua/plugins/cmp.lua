return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "zbirenbaum/copilot.lua", -- Copilot
  },
  opts = {
    keymap = {
      -- Blink only accepts predefined commands here
      ["<Tab>"] = { "snippet_forward", "select_and_accept", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
    },
    appearance = {
      nerd_font_variant = "mono",
    },
    signature = {
      enabled = true,
      window = {
        border = "rounded",
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        zindex = 50,
        max_height = 8,
        max_width = 80,
        scrolloff = 1,
      },
    },
    completion = {
      documentation = {
        auto_show = true,
        window = {
          border = "rounded",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          zindex = 50,
          max_height = 15,
          max_width = 100,
          scrolloff = 1,
        },
      },
      signature_help = {
        enabled = true,
        window = {
          border = "rounded",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          zindex = 50,
          max_height = 15,
          max_width = 100,
          scrolloff = 1,
        },
      },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
  },
  opts_extend = { "sources.default" },
  config = function(_, opts)
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
        -- fallback to Blink's <C-F> if mapped
        local blink = require("blink.cmp.keymap")
        blink.accept() -- or blink.fallback(), depending on your preference
      end
    end, { silent = true })
  end,
}
