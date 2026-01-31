return {
  "kdheepak/lazygit.nvim",
  cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
  },
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