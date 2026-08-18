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
  -- No completion hook here. The old one listened for "BlinkCmpCompleteDone",
  -- which blink.cmp never emits (its accept event is "BlinkCmpAccept"), so it
  -- was dead. Repointing it is not the fix either: on_confirm_done expects
  -- nvim-cmp's entry object and would error on blink's payload, and it exists
  -- to add brackets after a completion — which cmp.lua deliberately turns off
  -- via completion.accept.auto_brackets.enabled = false.
  --
  -- The InsertEnter block that followed it only re-required an already-loaded
  -- module, so it went too.
}
