return {
  "rachartier/tiny-code-action.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    -- you can omit the big pickers if you won’t use them
    -- { "nvim-telescope/telescope.nvim" },
    -- { "ibhagwan/fzf-lua" },
    -- { "folke/snacks.nvim", opts = { terminal = {}, } },
  },
  event = "LspAttach",
  opts = {
    backend = "vim", -- simplest diff preview, no external binary
    picker = {
      "buffer", -- choose the floating buffer picker
      opts = {
        hotkeys = true, -- enable single-letter hotkeys for actions
        hotkeys_mode = "text_diff_based", -- optional: smarter letters
        position = "center", -- place the floating window at center
        width = 0.60, -- optional: width fraction (60% of screen)
        height = 0.40, -- optional: height fraction (40% of screen)
        -- you can set keymaps inside, like esc to close:
        keymaps = {
          quit = { "<esc>", "q" },
        },
      },
    },
    resolve_timeout = 100, -- 100ms waiting for action resolution
    notify = {
      enabled = false, -- disable notifications for “no actions”
      on_empty = false,
    },
    signs = {
      quickfix = { "", { link = "DiagnosticWarning" } },
      others = { "", { link = "DiagnosticWarning" } },
      refactor = { "", { link = "DiagnosticInfo" } },
      ["refactor.move"] = { "󰪹", { link = "DiagnosticInfo" } },
      ["refactor.extract"] = { "", { link = "DiagnosticError" } },
      ["source.organizeImports"] = { "", { link = "DiagnosticWarning" } },
      ["source.fixAll"] = { "󰃢", { link = "DiagnosticError" } },
      ["source"] = { "", { link = "DiagnosticError" } },
      ["rename"] = { "󰑕", { link = "DiagnosticWarning" } },
      ["codeAction"] = { "", { link = "DiagnosticWarning" } },
    },
    -- optional: a filter to exclude less relevant actions
    filter = function(action, client)
      -- e.g. skip generic “Organize imports” if you don’t care
      if action.kind == "source.organizeImports" then
        return false
      end
      return true
    end,
  },
  keys = {
    {
      "<leader>ca",
      function()
        require("tiny-code-action").code_action()
      end,
      mode = { "n", "v" },
      desc = "Code Action (inline)",
    },
  },
}
