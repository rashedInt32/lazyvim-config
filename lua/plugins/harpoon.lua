return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()
  end,
  keys = {
    {
      "<C-e>",
      function()
        require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
      end,
      desc = "Toggle Harpoon Menu",
    },
    -- <leader>A, not <leader>a. As a complete mapping, <leader>a shadowed the
    -- whole sidekick group (<leader>aa/ac/af/ap/as/at/au/av), so every one of
    -- them sat waiting out timeoutlen before firing.
    {
      "<leader>A",
      function()
        require("harpoon"):list():add()
      end,
      desc = "Harpoon: Mark File",
    },
  },
}
