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
  end,
}
