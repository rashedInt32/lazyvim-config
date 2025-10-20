return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true,
    disable_filetype = { "TelescopePrompt", "vim" },
    map_cr = true, -- map <CR> (Enter) to handle pair insertion nicely
    map_bs = true,
    enable_check_bracket_line = true,
    ignored_next_char = "[%)%]%}\"']",
  },
}
