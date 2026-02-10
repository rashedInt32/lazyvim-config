return {
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = false,
  priority = 1000,
  opts = {
    variant = "moon", -- auto, main, moon, or dawn
    dark_variant = "main", -- main, moon, or dawn
    dim_inactive_windows = false,
    extend_background_behind_borders = true,
    enable = {
      terminal = true,
      legacy_highlights = true,
      migrations = true,
    },

    styles = {
      bold = true,
      italic = true,
      transparency = true,
    },

    groups = {
      border = "muted",
      link = "iris",
      panel = "surface",

      error = "love",
      hint = "iris",
      info = "foam",
      note = "pine",
      todo = "rose",
      warn = "gold",

      git_add = "foam",
      git_change = "rose",
      git_delete = "love",
      git_dirty = "rose",
      git_ignore = "muted",
      git_merge = "iris",
      git_rename = "pine",
      git_stage = "iris",
      git_text = "rose",
      git_untracked = "subtle",

      h1 = "iris",
      h2 = "foam",
      h3 = "rose",
      h4 = "gold",
      h5 = "pine",
      h6 = "foam",
    },

    palette = {
      moon = {
        base = "#011627",
        surface = "#1e2030",
        overlay = "#2f334d",
        muted = "#636da6",
        subtle = "#828bb8",
        text = "#e0def4",
        love = "#ff757f",
        gold = "#ffc777",
        rose = "#ff966c",
        pine = "#82aaff",
        foam = "#86e1fc",
        iris = "#fca7ea",
        leaf = "#c3e88d",
        highlight_low = "#2a283e",
        highlight_med = "#44415a",
        highlight_high = "#56526e",
      },
    },

    highlight_groups = {
      -- Comment = { fg = "foam" },
      -- StatusLine = { fg = "love", bg = "love", blend = 15 },
      -- VertSplit = { fg = "muted", bg = "muted" },
      -- Visual = { fg = "base", bg = "text", inherit = false },
    },

    before_highlight = function(group, highlight, palette)
      -- Disable all undercurls
      -- if highlight.undercurl then
      --     highlight.undercurl = false
      -- end
      --
      -- Change palette colour
      -- if highlight.fg == palette.pine then
      --     highlight.fg = palette.foam
      -- end
    end,
  },
  config = function(_, opts)
    require("rose-pine").setup(opts)
    -- Uncomment the line below to enable rose-pine by default
    -- vim.cmd("colorscheme rose-pine")
    -- vim.cmd("colorscheme rose-pine-main")
    -- vim.cmd("colorscheme rose-pine-moon")
    -- vim.cmd("colorscheme rose-pine-dawn")
  end,
}
