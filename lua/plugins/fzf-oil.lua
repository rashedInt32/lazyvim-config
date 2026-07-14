return {
  {
    "ingur/fzf-oil.nvim",
    dependencies = {
      {
        "ibhagwan/fzf-lua",
        -- single source of geometry: the oil float and the fzf picker are both
        -- sized from these, so <C-e>/<C-f> swap content without moving the window
        opts = {
          winopts = {
            height = 0.45,
            width = 0.98,
            row = 1,
            col = 0.5,
            border = "rounded",
            backdrop = false,
          },
        },
      },
      "stevearc/oil.nvim",
    },
    event = "VeryLazy",
    opts = {
      start_mode = "fzf",
      border = "rounded",
      -- list only: no preview pane, which also keeps oil from opening one on toggle
      fzf_exec_opts = {
        previewer = false,
        winopts = { preview = { hidden = true } },
      },
    },
    config = function(_, opts)
      local fzf_oil = require("fzf-oil")

      -- expose browse() for oil's <C-e>/<C-f> keymaps
      fzf_oil.browse = fzf_oil.setup(opts).browse

      -- fzf-oil skips its resize pass when oil already uses this override, which
      -- is what keeps the float from jumping when toggling back from fzf
      require("oil.config").float.override = fzf_oil.override
    end,
  },
}
