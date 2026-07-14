-- fuzzy-find across the whole project from oil; in the picker, <C-e> toggles
-- back to oil and <C-h>/<C-l> walk the tree
local function fzf_search()
  require("oil").close()
  -- let the float finish closing, else its frame ghosts under the picker
  vim.schedule(function()
    vim.cmd("redraw")
    require("fzf-oil").browse(vim.fn.getcwd(), true)
  end)
end

return {
  {
    "stevearc/oil.nvim",
    dependencies = {
      { "nvim-mini/mini.icons", opts = {} },
    },
    lazy = false,
    opts = {
      skip_confirm_for_simple_edits = true,
      delete_to_trash = true,
      watch_for_changes = true,
      constrain_cursor = "name",
      lsp_file_methods = {
        autosave_changes = true,
      },
      default_file_explorer = false,
      win_options = {
        signcolumn = "no",
        foldcolumn = "1",
      },
      confirmation = {
        border = "rounded",
        win_options = {
          winblend = 0,
        },
      },
      columns = {
        "icon",
      },
      keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<C-h>"] = { "actions.select", opts = { vertical = true } },
        ["<C-s>"] = false,
        ["<C-w>s"] = { "actions.select", opts = { horizontal = true } },
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["q"] = { "actions.close", mode = "n" },
        ["<C-l>"] = "actions.refresh",
        ["-"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["<C-f>"] = { callback = fzf_search, mode = "n", desc = "Find files in project" },
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
      },
      view_options = {
        show_hidden = false,
      },
      float = {
        padding = 2,
        max_width = 0,
        max_height = 0,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
        -- geometry (the bottom bar) is installed by fzf-oil in plugins/fzf-oil.lua,
        -- so this float and the fzf picker share one rect and toggling swaps in place
      },
    },
    config = function(_, opts)
      require("oil").setup(opts)

      vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })
    end,
  },
}
