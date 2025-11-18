return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true,
    disable_filetype = { "TelescopePrompt", "vim" },
    map_cr = false,
    map_bs = true,
    enable_check_bracket_line = false,
    ignored_next_char = "",
    fast_wrap = {},
  },
  config = function(_, opts)
    local npairs = require("nvim-autopairs")
    npairs.setup(opts)

    local has_blink, blink = pcall(require, "blink.cmp")
    if has_blink then
      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpCompleteDone",
        callback = function(event)
          npairs.on_confirm_done()(event)
        end,
      })
    end

    vim.api.nvim_create_autocmd("InsertEnter", {
      callback = function()
        vim.defer_fn(function()
          if not npairs then
            npairs = require("nvim-autopairs")
          end
        end, 10)
      end,
    })
  end,
}
