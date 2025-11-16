return {
  "stevearc/oil.nvim",
  dependencies = {
    { "nvim-mini/mini.icons", opts = {} },
  },
  lazy = false,
  opts = {
    default_file_explorer = false,
    columns = {
      "icon",
    },
    keymaps = {
      ["g?"] = { "actions.show_help", mode = "n" },
      ["<CR>"] = "actions.select",
      ["<C-s>"] = { "actions.select", opts = { vertical = true } },
      ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
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
      override = function(conf)
        conf.anchor = "SW"
        conf.row = vim.o.lines - 2
        conf.col = 0
        conf.width = vim.o.columns - 4
        conf.height = math.floor(vim.o.lines * 0.4)
        return conf
      end,
    },
  },
  config = function(_, opts)
    require("oil").setup(opts)

    local oil_parent_limit = function()
      local oil = require("oil")
      local current_dir = oil.get_current_dir()
      if current_dir then
        local parent = vim.fn.fnamemodify(current_dir, ":h:h")
        if parent and parent ~= "/" and parent ~= current_dir then
          oil.open(parent)
        end
      end
    end

    vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })
  end,
}
