return {
  "rachartier/tiny-code-action.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/snacks.nvim", -- use Snacks for picker
  },
  event = "LspAttach",
  opts = {
    backend = "vim", -- fast, dependency-free diff viewer
    picker = {
      "snacks",
      opts = {
        layout = {
          position = "cursor", -- open near cursor
          width = 0.45,
          height = "auto", -- adaptive height based on items
          border = "rounded",
        },
        ui = {
          input = false,
          prompt = false, -- no search input, just menu
          icons = true,
          title = false,
        },
        keymaps = {
          ["q"] = "close", -- close picker with 'q'
          ["<esc>"] = "close", -- also close with ESC
        },
      },
    },
    resolve_timeout = 150,
    notify = {
      enabled = false,
      on_empty = false,
    },
    signs = {
      quickfix = { "", { link = "DiagnosticWarning" } },
      refactor = { "", { link = "DiagnosticInfo" } },
      ["refactor.extract"] = { "", { link = "DiagnosticHint" } },
      ["source.organizeImports"] = { "", { link = "DiagnosticInfo" } },
      ["source.fixAll"] = { "󰃢", { link = "DiagnosticError" } },
      rename = { "󰑕", { link = "DiagnosticWarning" } },
    },
    filter = function(action)
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
        require("tiny-code-action").code_action({})
      end,
      mode = { "n", "v" },
      desc = "Code Action (Snacks)",
    },
  },
}
