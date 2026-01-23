return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000,
  config = function()
    require("tiny-inline-diagnostic").setup({
      -- Style preset for diagnostic messages
      -- Available options: "modern", "classic", "minimal", "powerline", "ghost", "simple", "nonerdfont", "amongus"
      preset = "modern",

      -- Set the background of the diagnostic to transparent
      transparent_bg = false,

      -- Set the background of the cursorline to transparent (only for the first diagnostic)
      -- Default is true in the source code, not false as in the old README
      transparent_cursorline = true,

      hi = {
        -- Highlight group for error messages
        error = "DiagnosticError",

        -- Highlight group for warning messages
        warn = "DiagnosticWarn",

        -- Highlight group for informational messages
        info = "DiagnosticInfo",

        -- Highlight group for hint or suggestion messages
        hint = "DiagnosticHint",

        -- Highlight group for diagnostic arrows
        arrow = "NonText",

        -- Background color for diagnostics
        -- Can be a highlight group or a hexadecimal color (#RRGGBB)
        background = "None",

        -- Color blending option for the diagnostic background
        -- Use "None" or a hexadecimal color (#RRGGBB) to blend with another color
        -- Default is "Normal" in the source code
        mixing_color = "Normal",
      },

      options = {
        -- Display the source of the diagnostic (e.g., basedpyright, vsserver, lua_ls etc.)
        show_source = {
          enabled = false,
          -- Show source only when multiple sources exist for the same diagnostic
          if_many = false,
        },

        -- Use icons defined in the diagnostic configuration instead of preset icons
        use_icons_from_diagnostic = false,

        -- Set the arrow icon to the same color as the first diagnostic severity
        set_arrow_to_diag_color = false,

        -- Add messages to diagnostics when multiline diagnostics are enabled
        -- If set to false, only signs will be displayed
        add_messages = true,

        -- Time (in milliseconds) to throttle updates while moving the cursor
        -- Increase this value for better performance on slow computers
        -- Set to 0 for immediate updates and better visual feedback
        throttle = 20,

        -- Minimum message length before wrapping to a new line
        softwrap = 40,

        -- Configuration for multiline diagnostics
        -- Can be a boolean or a table with detailed options
        multilines = {
          -- Enable multiline diagnostic messages
          enabled = false,

          -- Always show messages on all lines for multiline diagnostics
          always_show = false,

          -- Trim whitespaces from the start/end of each line
          trim_whitespaces = false,

          -- Replace tabs with this many spaces in multiline diagnostics
          tabstop = 4,
        },

        -- Display all diagnostic messages on the cursor line, not just those under cursor
        show_all_diags_on_cursorline = false,

        -- Enable diagnostics in Insert mode
        -- If enabled, consider setting throttle to 0 to avoid visual artifacts
        enable_on_insert = false,

        -- Enable diagnostics in Select mode (e.g., when auto-completing with Blink)
        enable_on_select = false,

        -- Manage how diagnostic messages handle overflow
        overflow = {
          -- Overflow handling mode:
          -- "wrap" - Split long messages into multiple lines
          -- "none" - Do not truncate messages
          -- "oneline" - Keep the message on a single line, even if it's long
          mode = "wrap",

          -- Trigger wrapping this many characters earlier when mode == "wrap"
          -- Increase if the last few characters of wrapped diagnostics are obscured
          padding = 0,
        },

        -- Configuration for breaking long messages into separate lines
        break_line = {
          -- Enable breaking messages after a specific length
          enabled = false,

          -- Number of characters after which to break the line
          after = 30,
        },

        format = function(diagnostic)
          local msg = diagnostic.message
          local source = diagnostic.source or ""

          if source:match("typescript") or source:match("ts") or source:match("vtsls") then
            local expected, got = msg:match("Type '(.-)' is not assignable to type '(.-)'%.?$")
            if not expected then
              got, expected = msg:match("Argument of type '(.-)' is not assignable to parameter of type '(.-)'%.?$")
            end
            if expected and got then
              got = got:gsub("import%([^)]+%)%.", ""):sub(1, 50)
              expected = expected:gsub("import%([^)]+%)%.", ""):sub(1, 50)
              if #got > 50 then got = got .. "…" end
              if #expected > 50 then expected = expected .. "…" end
              return "✗ " .. got .. " → ✓ " .. expected
            end

            local prop = msg:match("Property '(.-)' is missing")
            if prop then
              return "◈ Missing: '" .. prop .. "'"
            end

            local missing_prop = msg:match("Property '(.-)' does not exist")
            if missing_prop then
              return "✗ Unknown: '" .. missing_prop .. "'"
            end

            local name = msg:match("Cannot find name '(.-)'")
            if name then
              return "✗ Undefined: '" .. name .. "'"
            end

            local module_path = msg:match("Cannot find module '(.-)'")
            if module_path then
              return "✗ Module: '" .. module_path:gsub(".*/", "") .. "'"
            end

            local implicit = msg:match("Parameter '(.-)' implicitly has an 'any'")
            if implicit then
              return "⚠ Needs type: '" .. implicit .. "'"
            end

            if msg:match("Object is possibly") then
              return "⚠ Possibly nullish"
            end

            local ok, formatter = pcall(require, "format-ts-errors")
            if ok and diagnostic.code then
              local format_func = formatter[diagnostic.code]
              if format_func and type(format_func) == "function" then
                local formatted = format_func(msg)
                if formatted and formatted ~= "" then
                  formatted = formatted:gsub("```typescript\n", ""):gsub("```ts\n", ""):gsub("\n```", "")
                  if #formatted > 100 then
                    formatted = formatted:sub(1, 97) .. "…"
                  end
                  return formatted
                end
              end
            end
          end

          if #msg > 100 then
            return msg:sub(1, 97) .. "…"
          end
          return msg
        end,

        -- Virtual text display configuration
        virt_texts = {
          -- Priority for virtual text display (higher values appear on top)
          -- Increase if other plugins (like GitBlame) override diagnostics
          priority = 2048,
        },

        -- Filter diagnostics by severity levels
        -- Available severities: vim.diagnostic.severity.ERROR, WARN, INFO, HINT
        severity = {
          vim.diagnostic.severity.ERROR,
          vim.diagnostic.severity.WARN,
          vim.diagnostic.severity.INFO,
          vim.diagnostic.severity.HINT,
        },

        -- Events to attach diagnostics to buffers
        -- Default: { "LspAttach" }
        -- Only change if the plugin doesn't work with your configuration
        overwrite_events = nil,
      },

      -- List of filetypes to disable the plugin for
      disabled_ft = {},
    })
    vim.diagnostic.config({ virtual_text = false }) -- Disable default virtual text
  end,
}
