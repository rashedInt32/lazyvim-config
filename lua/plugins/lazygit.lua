return {
  "kdheepak/lazygit.nvim",
  cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
  -- <leader>gg intentionally handled by Snacks.lazygit() (see snacks.lua) so that
  -- pressing `e` opens the file in the previous window instead of a nested nvim.
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local ok, telescope = pcall(require, "telescope")
    if ok then
      telescope.load_extension("lazygit")
    end
  end,
}