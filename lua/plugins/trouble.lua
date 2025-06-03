return {
  "folke/trouble.nvim",
  opts = {
    -- Keep default settings unless overriding
    use_diagnostic_signs = true,

    -- Optional: you can override action keys if you want to customize <CR>
    -- Uncomment below if you want to customize <CR> behavior in Trouble
    -- action_keys = {
    --   open = function()
    --     local trouble = require("trouble")
    --     local state = trouble.state
    --     local item = state.get_selected()
    --     if item then
    --       vim.api.nvim_win_set_cursor(0, { item.lnum + 1, item.col })
    --       trouble.close()
    --       vim.diagnostic.open_float(nil, { scope = "cursor" })
    --     end
    --   end,
    -- },
  },

  config = function(_, opts)
    require("trouble").setup(opts)

    -- Float diagnostic window after jumping from Trouble
    vim.api.nvim_create_autocmd("BufWinEnter", {
      pattern = "*",
      callback = function()
        -- Defer a bit so cursor lands on the diagnostic first
        vim.defer_fn(function()
          if vim.bo.filetype ~= "Trouble" then
            vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
          end
        end, 50)
      end,
    })
  end,
}
