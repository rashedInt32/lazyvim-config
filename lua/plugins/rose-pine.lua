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
        base = "#011627", -- Night Owl Background
        surface = "#011f35",
        overlay = "#0b2942",
        muted = "#6a8080", -- Night Owl Slate Comments
        subtle = "#637777", -- Muted Steel for punctuation
        rose = "#ff7eb6", -- Metadata/Async
        pine = "#7fdbca", -- Constants/Booleans
        foam = "#7dcfff", -- Functions
        iris = "#c792ea", -- Classes/Booleans
        love = "#ff5189", -- Keywords/Flow
        gold = "#e0af68", -- Types (TokyoNight Gold)

        -- NEW PREMIUM VARIABLES
        --mint = "#f2ceb6", -- Parameters (Italicized)
        mint = "#b4befe", -- Parameters (Italicized)
        olive = "#addb67", -- Strings & SQL
      },
    },

    highlight_groups = {
      -- 1. THE "CALM" ENGINE (Muted punctuation)
      ["@punctuation.bracket"] = { fg = "subtle" },
      ["@operator"] = { fg = "subtle" },
      ["@comment"] = { fg = "muted", italic = true },

      -- 1. THE IMPORT IDENTIFIER FIX
      -- This forces the actual names inside the { } to stay vibrant Rose.
      ["@variable.import"] = { fg = "rose" },
      ["@lsp.type.import"] = { fg = "rose" },
      ["@variable.typescript"] = { fg = "rose" },

      -- 2. THE SPECIFIC TS/TSX OVERRIDE
      -- TypeScript often uses specific tags for symbols in the import statement.
      ["@include.typescript"] = { fg = "love" }, -- The 'import' and 'from' keywords
      ["@variable.parameter.typescript"] = { fg = "rose" }, -- Sometimes imports are tagged this way

      -- 3. THE "DESTRUCTURING" FIX
      -- Since you are destructuring the imports { a, b },
      -- we ensure property-like identifiers stay bright.
      ["@variable.member.typescript"] = { fg = "rose" },

      -- 4. CLEAN UP THE COMMAS
      -- This ensures only the commas and braces stay muted, not the text.

      -- This ensures that when you use a variable as a value,
      -- it keeps its "Data" color (Lavender) instead of the "Key" color.

      -- This targets the ":" delimiter to make sure it doesn't
      -- glow as bright as the text, which helps the separation.

      -- 2. SHORTHAND PROPERTY FIX
      -- If you use { email } instead of { email: email },
      -- this ensures it still looks intentional.
      ["@punctuation.delimiter"] = { fg = "subtle" }, -- Mutes the ':'

      -- 2. LOGIC & ACTION (Action Pink) - NO BOLD/ITALIC on keywords
      ["@keyword.conditional"] = { fg = "love" },
      ["@keyword.return"] = { fg = "love" },
      ["@keyword.function"] = { fg = "love" },
      ["@punctuation.special"] = { fg = "love" }, -- The '*' in function*

      -- 3. STRUCTURE (Iris/Purple)
      ["@keyword.storage"] = { fg = "iris" }, -- const, let
      ["@keyword.modifier"] = { fg = "rose" },

      -- 4. PARAMETERS (Electric Lavender - The Star)
      ["@variable.parameter"] = { fg = "mint", italic = true },
      ["@lsp.type.parameter"] = { fg = "mint", italic = true },
      ["@lsp.mod.declaration.typescript"] = { fg = "mint", italic = true },

      -- 5. THE "SQL" & VARIABLE FIX (Making them visible again)
      -- We keep generic variables muted, but elevate "Member" variables and
      -- specific LSP types so things like 'sql' or 'Effect' stay bright.
      ["@variable"] = { fg = "subtle" },
      ["@variable.member"] = { fg = "foam" }, -- Ensures result.length is visible
      ["@lsp.type.variable"] = { fg = "mint" }, -- Slightly brighter than subtle
      ["@lsp.type.property"] = { fg = "foam" },
      ["@lsp.type.namespace"] = { fg = "iris" }, -- Keeps 'Effect' or 'Layer' purple

      -- 6. DATA & TYPES (The Architecture) - NO BOLD on types
      ["@type"] = { fg = "gold" },
      ["@type.interface"] = { fg = "gold" },
      ["@lsp.type.type"] = { fg = "gold" },
      ["@lsp.type.class"] = { fg = "iris" },
      ["@string"] = { fg = "olive" },
      ["@constant"] = { fg = "pine" },

      -- 7. UI ACCENTS
      Visual = { bg = "#1b2e3f", inherit = false },
      CursorLine = { bg = "#081d2f" },
      LineNr = { fg = "#3b4261" },
      CursorLineNr = { fg = "foam", bold = true },
    },
  },
  config = function(_, opts)
    require("rose-pine").setup(opts)
    vim.cmd("colorscheme rose-pine")

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
      pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.lua" },
      callback = function()
        vim.fn.matchadd("CoroutineKeyword", "\\<yield\\>", 100)
        vim.fn.matchadd("CoroutineKeyword", "\\<await\\>", 100)
        vim.fn.matchadd("CoroutineKeyword", "\\<async\\>", 100)
      end,
    })

    vim.api.nvim_set_hl(0, "CoroutineKeyword", { fg = "#ff7eb6", italic = true })
  end,
}
