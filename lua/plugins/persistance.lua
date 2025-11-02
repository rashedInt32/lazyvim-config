return {
  "folke/persistence.nvim",
  event = "BufReadPre", -- Load the plugin before any buffer is read
  opts = {
    -- dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"), -- Optional: customize session directory
    -- log_level = vim.log.levels.INFO, -- Optional: set log level
    excluded_filetypes = {
      "TelescopePrompt",
      "neo-tree",
      "help",
      "markdown", -- Optional: exclude markdown if you don't want sessions for it
      "nvim-tree",
      "lazy",
      "alpha",
      "dashboard",
      "Trouble",
      "lspinfo",
      "Outline",
      "qf",
      "spectre_panel",
      "neotest-output",
      "neotest-summary",
      "original",
      "diff",
      "man",
      "lspsagaoutline",
      "kine-inlay",
      "FTerm",
      "toggleterm",
      "nvterm",
      "NvimTree",
      "terminal",
      -- Add the snacks explorer filetype exclusion here:
      "snacks_picker_list",
    },
    -- If you want to automatically save and restore the last session
    -- autosave = {
    --   enabled = true,
    --   limit = 1, -- Limit to 1 session to auto-restore the last one
    --   lasti = true,
    --   cwd = true, -- Save the current working directory
    -- },
    -- autoclean = {
    --   enabled = true,
    --   -- DANGER: this will clean all sessions not in the current directory
    --   -- this is useful if you use the cwd option
    --   -- a safer way is to just use a fixed directory
    --   -- (see the dir option above)
    --   -- test this with the log_level set to INFO
    --   -- trigger = "VimLeavePre",
    -- },
  },
  -- Optional: add keymaps directly here if you wish
  keys = {
    {
      "<leader>qs",
      function()
        require("persistence").load()
      end,
      desc = "Restore Session",
    },
    {
      "<leader>ql",
      function()
        require("persistence").load({ last = true })
      end,
      desc = "Restore Last Session",
    },
    {
      "<leader>qd",
      function()
        require("persistence").stop()
      end,
      desc = "Don't Save Current Session",
    },
  },
}
