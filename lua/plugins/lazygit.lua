return {
  "kdheepak/lazygit.nvim",
  cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
  -- <leader>gg intentionally handled by Snacks.lazygit() (see snacks.lua) so that
  -- pressing `e` opens the file in the previous window instead of a nested nvim.
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  -- No config here. It used to pcall-require telescope and load an extension;
  -- telescope is not installed (Snacks.picker replaced it), so the pcall always
  -- failed and the block did nothing.
}
