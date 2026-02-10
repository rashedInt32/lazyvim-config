return {
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = false,
  priority = 1000,
  opts = {
    variant = "main",
    dark_variant = "main",
    styles = {
      bold = true,
      italic = true,
      transparency = false,
    },

    palette = {
      main = {
        base = "#011627",
        surface = "#011f35",
        overlay = "#0b2942",

        -- AUTHENTIC NIGHT OWL COMMENTS
        muted = "#6a8080", -- Tokyo Night Gray (Comments)
        subtle = "#565f89", -- Tokyo Night Muted (Punctuation)

        -- SYNTAX COLORS (Carefully curated from all three themes)
        iris = "#c792ea", -- Night Owl Purple (Functions)
        pine = "#9ece6a", -- Tokyo Night Green (Constants)
        foam = "#7dcfff", -- Tokyo Night Cyan (Variables/Properties)
        leaf = "#c3e88d", -- Tokyo Night Light Green (Strings)
        rose = "#ff7eb6", -- Rose Pine Pink (Keywords/Control Flow)
        love = "#ff5189", -- Neon Pink (Errors/Warnings)

        -- ADDITIONAL PREMIUM COLORS
        orange = "#7aa2f7", -- Night Owl Orange (Numbers)
        sky = "#82aaff", -- Night Owl Blue (Methods/Secondary Functions)
        lavender = "#bb9af7", -- Tokyo Night Lavender (Special Functions)
        teal = "#7fdbca", -- Seafoam (Booleans/Tags)
      },
    },

    highlight_groups = {
      -- ═══════════════════════════════════════════════════════════
      -- PHASE 1: CORE SYNTAX (Treesitter)
      -- ═══════════════════════════════════════════════════════════

      -- Comments (Tokyo Night Muted)
      ["Comment"] = { fg = "#565f89", italic = true },
      ["@comment"] = { fg = "#565f89", italic = true },
      ["@comment.documentation"] = { fg = "#565f89", italic = true },

      -- Keywords & Control Flow (Rose Pine Pink)
      ["@keyword"] = { fg = "#ff7eb6", italic = true },
      ["@keyword.conditional"] = { fg = "#ff7eb6", italic = true },
      ["@keyword.repeat"] = { fg = "#ff7eb6", italic = true },
      ["@keyword.return"] = { fg = "#ff7eb6", italic = true },
      ["@keyword.import"] = { fg = "#ff7eb6" },
      ["@keyword.export"] = { fg = "#ff7eb6" },
      ["@keyword.exception"] = { fg = "#ff7eb6", italic = true },

      -- Access Modifiers (Tokyo Night Blue - darker cyan)
      ["@keyword.modifier"] = { fg = "#7aa2f7", italic = true },
      ["@keyword.function"] = { fg = "#7aa2f7" },

      -- Functions (Tokyo Night Bluish-Purple)
      ["@function"] = { fg = "#7aa2f7" },
      ["@function.builtin"] = { fg = "#7aa2f7", italic = true },
      ["@function.macro"] = { fg = "#7aa2f7" },
      ["@function.call"] = { fg = "#7aa2f7" },

      -- Methods (Tokyo Night Soft Purple - distinct from functions)
      ["@method"] = { fg = "#bb9af7" },
      ["@method.call"] = { fg = "#bb9af7" },

      -- Variables (Tokyo Night Light Blue - distinct from methods)
      ["@variable"] = { fg = "#82aaff" },
      ["@variable.builtin"] = { fg = "#82aaff", italic = true },
      ["@variable.parameter"] = { fg = "#86e1fc" }, -- Tokyo Night Moon Cyan

      -- Properties/Members (Darker Cyan for distinction)
      ["@variable.member"] = { fg = "#73daca" },
      ["@field"] = { fg = "#73daca" },
      ["@property"] = { fg = "#73daca" },

      -- Types (Lavender - NO MORE GOLD!)
      ["@type"] = { fg = "#bb9af7" },
      ["@type.builtin"] = { fg = "#bb9af7", italic = true },
      ["@type.definition"] = { fg = "#bb9af7", bold = true },
      ["@type.qualifier"] = { fg = "#bb9af7" },

      -- Constants (Tokyo Night Green)
      ["@constant"] = { fg = "#9ece6a" },
      ["@constant.builtin"] = { fg = "#9ece6a", italic = true },
      ["@constant.macro"] = { fg = "#9ece6a" },

      -- Strings (Tokyo Night Light Green)
      ["@string"] = { fg = "#c3e88d" },
      ["@string.documentation"] = { fg = "#c3e88d" },
      ["@string.regex"] = { fg = "#bb9af7" }, -- Lavender for regex
      ["@string.escape"] = { fg = "#7aa2f7" }, -- Orange for escapes
      ["@string.special"] = { fg = "#7aa2f7" },

      -- Characters
      ["@character"] = { fg = "#c3e88d" },
      ["@character.special"] = { fg = "#7aa2f7" },

      -- Numbers (Night Owl Orange)
      ["@number"] = { fg = "#7aa2f7" },
      ["@number.float"] = { fg = "#7aa2f7" },

      -- Booleans (Tokyo Night Moon Magenta)
      ["@boolean"] = { fg = "#c099ff", italic = true },

      -- Tags (Tokyo Night Moon Teal)
      ["@tag"] = { fg = "#4fd6be" },
      ["@tag.attribute"] = { fg = "#86e1fc" },
      ["@tag.delimiter"] = { fg = "#565f89" },

      -- Operators (Tokyo Night Light Blue)
      ["@operator"] = { fg = "#89ddff" },

      -- Punctuation (Muted Tokyo Night)
      ["@punctuation"] = { fg = "#565f89" },
      ["@punctuation.delimiter"] = { fg = "#565f89" },
      ["@punctuation.bracket"] = { fg = "#565f89" },
      ["@punctuation.special"] = { fg = "#89ddff" }, -- Light blue for special

      -- Labels (Rose Pine Pink)
      ["@label"] = { fg = "#ff7eb6" },

      -- Namespaces/Modules (Lavender - NO MORE GOLD!)
      ["@namespace"] = { fg = "#bb9af7" },
      ["@module"] = { fg = "#bb9af7" },

      -- ═══════════════════════════════════════════════════════════
      -- PHASE 2: LSP SEMANTIC HIGHLIGHTING
      -- ═══════════════════════════════════════════════════════════
      ["@lsp.type.function"] = { fg = "#7aa2f7" },
      ["@lsp.type.method"] = { fg = "#bb9af7" },
      ["@lsp.type.variable"] = { fg = "#82aaff" },
      ["@lsp.type.property"] = { fg = "#73daca" },
      ["@lsp.type.parameter"] = { fg = "#86e1fc" },
      ["@lsp.type.class"] = { fg = "#bb9af7" },
      ["@lsp.type.interface"] = { fg = "#bb9af7" },
      ["@lsp.type.enum"] = { fg = "#bb9af7" },
      ["@lsp.type.enumMember"] = { fg = "#9ece6a" },
      ["@lsp.type.struct"] = { fg = "#bb9af7" },
      ["@lsp.type.type"] = { fg = "#bb9af7" },
      ["@lsp.type.typeParameter"] = { fg = "#bb9af7" },
      ["@lsp.type.namespace"] = { fg = "#bb9af7" },
      ["@lsp.type.keyword"] = { fg = "#ff7eb6", italic = true },
      ["@lsp.type.comment"] = { fg = "#6a8080", italic = true },
      ["@lsp.type.string"] = { fg = "#c3e88d" },
      ["@lsp.type.number"] = { fg = "#7aa2f7" },
      ["@lsp.type.regexp"] = { fg = "#bb9af7" },
      ["@lsp.type.operator"] = { fg = "#89ddff" },
      ["@lsp.type.decorator"] = { fg = "#bb9af7" },
      ["@lsp.type.macro"] = { fg = "#7aa2f7" },

      -- LSP Modifiers
      ["@lsp.mod.abstract"] = { italic = true },
      ["@lsp.mod.async"] = { italic = true },
      ["@lsp.mod.readonly"] = { fg = "#9ece6a" },
      ["@lsp.mod.static"] = { bold = true },

      -- ═══════════════════════════════════════════════════════════
      -- PHASE 3: UI ELEMENTS
      -- ═══════════════════════════════════════════════════════════

      -- Selection & Search
      Visual = { bg = "#1d3b53", inherit = false },
      VisualNOS = { bg = "#1d3b53" },
      CursorLine = { bg = "#021320" },
      CursorColumn = { bg = "#021320" },
      Search = { bg = "#2d4f67", fg = "#c0caf5", bold = true },
      IncSearch = { bg = "#bb9af7", fg = "#011627", bold = true }, -- Lavender instead of gold
      CurSearch = { bg = "#ff7eb6", fg = "#011627", bold = true },
      MatchParen = { bg = "#2d4f67", bold = true },

      -- Line Numbers
      LineNr = { fg = "#3b4261" },
      CursorLineNr = { fg = "#7aa2f7", bold = true },

      -- Status & Cmd Line
      StatusLine = { bg = "#011f35", fg = "#c0caf5" },
      StatusLineNC = { bg = "#011627", fg = "#565f89" },

      -- Popups & Floats
      NormalFloat = { bg = "#011f35", fg = "#c0caf5" },
      FloatBorder = { fg = "#5f7e97", bg = "#011f35" },
      FloatTitle = { fg = "#7aa2f7", bg = "#011f35", bold = true },

      -- Pmenus
      Pmenu = { bg = "#011f35", fg = "#c0caf5" },
      PmenuSel = { bg = "#1d3b53", bold = true },
      PmenuSbar = { bg = "#011627" },
      PmenuThumb = { bg = "#565f89" },

      -- Sign Column
      SignColumn = { bg = "#011627" },

      -- Git Signs (using Night Owl colors)
      GitSignsAdd = { fg = "#9ccc65" },
      GitSignsChange = { fg = "#7aa2f7" }, -- Blue instead of gold
      GitSignsDelete = { fg = "#ef5350" },
      GitSignsAddInline = { bg = "#2f3e28" },
      GitSignsChangeInline = { bg = "#2a3f5f" }, -- Blue tinted instead of gold
      GitSignsDeleteInline = { bg = "#3f2828" },

      -- Diagnostics (Night Owl style)
      DiagnosticError = { fg = "#ff5189" },
      DiagnosticWarn = { fg = "#7aa2f7" },
      DiagnosticInfo = { fg = "#7aa2f7" },
      DiagnosticHint = { fg = "#4fd6be" },
      DiagnosticOk = { fg = "#9ece6a" },

      DiagnosticUnderlineError = { undercurl = true, sp = "#ff5189" },
      DiagnosticUnderlineWarn = { undercurl = true, sp = "#7aa2f7" },
      DiagnosticUnderlineInfo = { undercurl = true, sp = "#7aa2f7" },
      DiagnosticUnderlineHint = { undercurl = true, sp = "#4fd6be" },

      DiagnosticSignError = { fg = "#ff5189", bg = "#011627" },
      DiagnosticSignWarn = { fg = "#7aa2f7", bg = "#011627" },
      DiagnosticSignInfo = { fg = "#7aa2f7", bg = "#011627" },
      DiagnosticSignHint = { fg = "#4fd6be", bg = "#011627" },

      DiagnosticVirtualTextError = { fg = "#ff5189", bg = "#1a1025" },
      DiagnosticVirtualTextWarn = { fg = "#7aa2f7", bg = "#1a1510" },
      DiagnosticVirtualTextInfo = { fg = "#7aa2f7", bg = "#101520" },
      DiagnosticVirtualTextHint = { fg = "#4fd6be", bg = "#101a1a" },

      -- Spell Checking
      SpellBad = { undercurl = true, sp = "#ff5189" },
      SpellCap = { undercurl = true, sp = "#7aa2f7" }, -- Blue instead of gold
      SpellRare = { undercurl = true, sp = "#bb9af7" },
      SpellLocal = { undercurl = true, sp = "#4fd6be" },

      -- ═══════════════════════════════════════════════════════════
      -- PHASE 4: PLUGIN INTEGRATION
      -- ═══════════════════════════════════════════════════════════

      -- Telescope
      TelescopeNormal = { bg = "#011f35", fg = "#c0caf5" },
      TelescopeBorder = { fg = "#5f7e97", bg = "#011f35" },
      TelescopePromptNormal = { bg = "#092135" },
      TelescopePromptBorder = { fg = "#5f7e97", bg = "#092135" },
      TelescopePromptTitle = { fg = "#011627", bg = "#7aa2f7", bold = true },
      TelescopePreviewTitle = { fg = "#011627", bg = "#bb9af7", bold = true },
      TelescopeResultsTitle = { fg = "#011627", bg = "#9ece6a", bold = true },
      TelescopeSelection = { bg = "#1d3b53", bold = true },
      TelescopeSelectionCaret = { fg = "#ff7eb6", bold = true },
      TelescopeMatching = { fg = "#ff7eb6", bold = true },

      -- Neo-tree
      NeoTreeNormal = { bg = "#011f35", fg = "#c0caf5" },
      NeoTreeNormalNC = { bg = "#011f35", fg = "#565f89" },
      NeoTreeRootName = { fg = "#bb9af7", bold = true }, -- Lavender instead of gold
      NeoTreeDirectoryName = { fg = "#7dcfff" },
      NeoTreeDirectoryIcon = { fg = "#7aa2f7" },
      NeoTreeFileName = { fg = "#c0caf5" },
      NeoTreeFileIcon = { fg = "#6a8080" },
      NeoTreeGitAdded = { fg = "#9ccc65" },
      NeoTreeGitModified = { fg = "#7aa2f7" }, -- Blue instead of gold
      NeoTreeGitDeleted = { fg = "#ef5350" },
      NeoTreeGitConflict = { fg = "#ff5189", bold = true },
      NeoTreeGitUntracked = { fg = "#7aa2f7" },
      NeoTreeIndentMarker = { fg = "#1f395d" },
      NeoTreeExpander = { fg = "#565f89" },

      -- Which-key
      WhichKey = { fg = "#7aa2f7", bold = true },
      WhichKeyGroup = { fg = "#7dcfff" },
      WhichKeyDesc = { fg = "#c0caf5" },
      WhichKeySeparator = { fg = "#565f89" },
      WhichKeyFloat = { bg = "#011f35" },
      WhichKeyBorder = { fg = "#5f7e97" },

      -- Indent Blankline
      IblIndent = { fg = "#1f395d" },
      IblWhitespace = { fg = "#1f395d" },
      IblScope = { fg = "#5f7e97" },

      -- ═══════════════════════════════════════════════════════════
      -- STANDARD VIM HIGHLIGHTS
      -- ═══════════════════════════════════════════════════════════
      Normal = { bg = "#011627", fg = "#d6deeb" },
      Title = { fg = "#7aa2f7", bold = true },
      Bold = { bold = true },
      Italic = { italic = true },
      Underlined = { underline = true },

      -- Literals
      String = { fg = "#c3e88d" },
      Constant = { fg = "#9ece6a" },
      Character = { fg = "#c3e88d" },
      Number = { fg = "#7aa2f7" },
      Boolean = { fg = "#c099ff", italic = true },
      Float = { fg = "#7aa2f7" },

      -- Identifiers
      Identifier = { fg = "#82aaff" },
      Function = { fg = "#7aa2f7" },

      -- Statements
      Statement = { fg = "#ff7eb6", italic = true },
      Conditional = { fg = "#ff7eb6", italic = true },
      Repeat = { fg = "#ff7eb6", italic = true },
      Label = { fg = "#ff7eb6" },
      Operator = { fg = "#89ddff" },
      Keyword = { fg = "#ff7eb6", italic = true },
      Exception = { fg = "#ff7eb6", italic = true },

      -- Preprocessor
      PreProc = { fg = "#7aa2f7" },
      Include = { fg = "#7aa2f7" },
      Define = { fg = "#7aa2f7" },
      Macro = { fg = "#7aa2f7" },
      PreCondit = { fg = "#7aa2f7" },

      -- Types (Lavender instead of gold)
      Type = { fg = "#bb9af7" },
      StorageClass = { fg = "#bb9af7" },
      Structure = { fg = "#bb9af7" },
      Typedef = { fg = "#bb9af7" },

      -- Special
      Special = { fg = "#89ddff" },
      SpecialChar = { fg = "#7aa2f7" },
      Tag = { fg = "#4fd6be" },
      Delimiter = { fg = "#565f89" },
      SpecialComment = { fg = "#6a8080", italic = true },
      Debug = { fg = "#ff5189" },
    },
  },
  config = function(_, opts)
    require("rose-pine").setup(opts)
    vim.cmd("colorscheme rose-pine")

    -- Apply transparency if enabled
    if opts.styles.transparency then
      local hl = vim.api.nvim_set_hl
      hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
      hl(0, "NormalFloat", { bg = "#011f35" })
      hl(0, "NeoTreeNormal", { bg = "NONE" })
      hl(0, "NeoTreeNormalNC", { bg = "NONE" })
    end

    -- Re-apply highlights after LSP attaches (prevents override)
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function()
        vim.schedule(function()
          vim.api.nvim_set_hl(0, "@function", { fg = "#7aa2f7" })
          vim.api.nvim_set_hl(0, "@method", { fg = "#bb9af7" })
          vim.api.nvim_set_hl(0, "@variable", { fg = "#82aaff" })
          vim.api.nvim_set_hl(0, "@lsp.type.function", { fg = "#7aa2f7" })
          vim.api.nvim_set_hl(0, "@lsp.type.method", { fg = "#bb9af7" })
          vim.api.nvim_set_hl(0, "@lsp.type.variable", { fg = "#82aaff" })
        end)
      end,
    })

    -- Create autocmd to ensure highlights persist
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "rose-pine",
      callback = function()
        -- Re-apply critical highlights after colorscheme reload
        vim.api.nvim_set_hl(0, "CursorLine", { bg = "#021320" })
        vim.api.nvim_set_hl(0, "Visual", { bg = "#1d3b53" })
        vim.api.nvim_set_hl(0, "Comment", { fg = "#565f89", italic = true })
        vim.api.nvim_set_hl(0, "@function", { fg = "#7aa2f7" })
        vim.api.nvim_set_hl(0, "@method", { fg = "#bb9af7" })
        vim.api.nvim_set_hl(0, "@variable", { fg = "#82aaff" })
        vim.api.nvim_set_hl(0, "@lsp.type.function", { fg = "#7aa2f7" })
        vim.api.nvim_set_hl(0, "@lsp.type.method", { fg = "#bb9af7" })
        vim.api.nvim_set_hl(0, "@lsp.type.variable", { fg = "#82aaff" })
      end,
    })
  end,
}
