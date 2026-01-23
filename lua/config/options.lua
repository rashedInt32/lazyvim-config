-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true

-- line number and relative line number
vim.opt.number = false
vim.opt.relativenumber = false

--vim.opt.colorcolumn = "80"
--
vim.filetype.add({
  extension = {
    ["blade.php"] = "blade",
  },
})

vim.opt.guicursor = {
  "n-v-c:block", -- Normal mode: block
  "i-ci-ve:ver25", -- Insert mode: vertical bar
  "r-cr:hor20", -- Replace mode: horizontal
  "o:hor50", -- Operator pending
}

-- Override tab width for Go files (4 spaces)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = false -- Go generally uses tabs, not spaces
  end,
})

-- 1. Custom signs (gutter icons)
local signs = {
  Error = " ",
  Warn = " ",
  Info = " ",
  Hint = "󰌵 ",
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- 2. Configure diagnostics
local function prettify_type(type_str, max_len)
  max_len = max_len or 50
  if not type_str or #type_str <= max_len then
    return type_str
  end

  type_str = type_str
    :gsub("import%([^)]+%)%.", "") -- remove import("path").
    :gsub("import%([^)]+%)", "ᴵ") -- shorten remaining imports
    :gsub("readonly ", "")
    :gsub("React%.ReactNode", "ReactNode")
    :gsub("React%.ReactElement", "ReactEl")
    :gsub("React%.FC", "FC")
    :gsub("Promise<void>", "Promise<∅>")
    :gsub("undefined", "∅")
    :gsub("null", "∅")

  if #type_str > max_len then
    local props_match = type_str:match("^{ (.+) }$")
    if props_match then
      local props = {}
      local count = 0
      for prop in props_match:gmatch("([^;]+);?") do
        count = count + 1
        if count <= 2 then
          table.insert(props, vim.trim(prop))
        end
      end
      if count > 2 then
        type_str = "{ " .. table.concat(props, "; ") .. "; ⋯" .. (count - 2) .. " more }"
      end
    end
  end

  if #type_str > max_len then
    type_str = type_str:sub(1, max_len - 1) .. "…"
  end

  return type_str
end

local function format_ts_artistic(diagnostic)
  local msg = diagnostic.message
  local code = diagnostic.code
  local lines = {}

  local expected, got = msg:match("Type '(.-)' is not assignable to type '(.-)'%.?$")
  if not expected then
    got, expected = msg:match("Argument of type '(.-)' is not assignable to parameter of type '(.-)'%.?$")
  end

  if expected and got then
    got = prettify_type(got, 60)
    expected = prettify_type(expected, 60)
    table.insert(lines, "╭─ Type Mismatch")
    table.insert(lines, "│")
    table.insert(lines, "│  ✗ Got:      " .. got)
    table.insert(lines, "│  ✓ Expected: " .. expected)
    table.insert(lines, "╰─")
    return table.concat(lines, "\n")
  end

  local prop, in_type, req_type = msg:match("Property '(.-)' is missing in type '(.-)' but required in type '(.-)'")
  if prop then
    in_type = prettify_type(in_type, 40)
    req_type = prettify_type(req_type, 40)
    table.insert(lines, "╭─ Missing Property")
    table.insert(lines, "│")
    table.insert(lines, "│  ◈ Property:  '" .. prop .. "'")
    table.insert(lines, "│  ◇ In:        " .. in_type)
    table.insert(lines, "│  ◆ Required:  " .. req_type)
    table.insert(lines, "╰─")
    return table.concat(lines, "\n")
  end

  local missing_prop, on_type = msg:match("Property '(.-)' does not exist on type '(.-)'")
  if missing_prop then
    on_type = prettify_type(on_type, 50)
    table.insert(lines, "╭─ Unknown Property")
    table.insert(lines, "│")
    table.insert(lines, "│  ✗ '" .. missing_prop .. "' not found")
    table.insert(lines, "│  ◇ on type: " .. on_type)
    table.insert(lines, "╰─")
    return table.concat(lines, "\n")
  end

  local name_not_found = msg:match("Cannot find name '(.-)'")
  if name_not_found then
    table.insert(lines, "╭─ Undefined Reference")
    table.insert(lines, "│")
    table.insert(lines, "│  ✗ '" .. name_not_found .. "' is not defined")
    table.insert(lines, "╰─")
    return table.concat(lines, "\n")
  end

  local module_path = msg:match("Cannot find module '(.-)' or its corresponding type declarations")
  if module_path then
    table.insert(lines, "╭─ Module Not Found")
    table.insert(lines, "│")
    table.insert(lines, "│  ✗ '" .. module_path .. "'")
    table.insert(lines, "│  ⚡ Check path or install types")
    table.insert(lines, "╰─")
    return table.concat(lines, "\n")
  end

  local no_export_module, no_export_member = msg:match("Module '\"(.-)\"' has no exported member '(.-)'")
  if not no_export_module then
    no_export_module, no_export_member = msg:match("Module '(.-)' has no exported member '(.-)'")
  end
  if no_export_module and no_export_member then
    table.insert(lines, "╭─ Export Not Found")
    table.insert(lines, "│")
    table.insert(lines, "│  ✗ '" .. no_export_member .. "'")
    table.insert(lines, "│  ◇ not exported from '" .. no_export_module:gsub(".*/", "") .. "'")
    table.insert(lines, "╰─")
    return table.concat(lines, "\n")
  end

  local implicit_param = msg:match("Parameter '(.-)' implicitly has an 'any' type")
  if implicit_param then
    table.insert(lines, "╭─ Implicit Any")
    table.insert(lines, "│")
    table.insert(lines, "│  ⚠ '" .. implicit_param .. "' needs type annotation")
    table.insert(lines, "╰─")
    return table.concat(lines, "\n")
  end

  local var_used_before = msg:match("Variable '(.-)' is used before being assigned")
  if var_used_before then
    table.insert(lines, "╭─ Uninitialized Variable")
    table.insert(lines, "│")
    table.insert(lines, "│  ✗ '" .. var_used_before .. "' used before assignment")
    table.insert(lines, "╰─")
    return table.concat(lines, "\n")
  end

  local obj_possibly = msg:match("Object is possibly '(.-)'")
  if obj_possibly then
    table.insert(lines, "╭─ Nullish Reference")
    table.insert(lines, "│")
    table.insert(lines, "│  ⚠ Object may be " .. obj_possibly)
    table.insert(lines, "│  ⚡ Add optional chaining (?.) or null check")
    table.insert(lines, "╰─")
    return table.concat(lines, "\n")
  end

  local expect_args, got_args = msg:match("Expected (%d+) arguments?, but got (%d+)")
  if expect_args then
    table.insert(lines, "╭─ Argument Count")
    table.insert(lines, "│")
    table.insert(lines, "│  ✗ Got " .. got_args .. " args, expected " .. expect_args)
    table.insert(lines, "╰─")
    return table.concat(lines, "\n")
  end

  local const_name = msg:match("Cannot assign to '(.-)' because it is a constant")
  if const_name then
    table.insert(lines, "╭─ Constant Assignment")
    table.insert(lines, "│")
    table.insert(lines, "│  ✗ '" .. const_name .. "' is readonly")
    table.insert(lines, "╰─")
    return table.concat(lines, "\n")
  end

  if msg:match("has no call signatures") then
    local type_name = msg:match("Type '(.-)' has no call signatures")
    type_name = type_name and prettify_type(type_name, 40) or "Expression"
    table.insert(lines, "╭─ Not Callable")
    table.insert(lines, "│")
    table.insert(lines, "│  ✗ " .. type_name .. " is not a function")
    table.insert(lines, "╰─")
    return table.concat(lines, "\n")
  end

  return nil
end

vim.diagnostic.config({
  update_in_insert = false,
  severity_sort = true,
  signs = true,
  virtual_text = false,
  underline = false,

  float = {
    border = "rounded",
    source = true,
    header = "",
    prefix = "",

    suffix = function(diagnostic)
      if diagnostic.code then
        return string.format(" [%s]", diagnostic.code), "DiagnosticHintItalic"
      end
      return "", ""
    end,

    format = function(diagnostic)
      local icon_map = {
        [vim.diagnostic.severity.ERROR] = { " ", "DiagnosticError" },
        [vim.diagnostic.severity.WARN] = { " ", "DiagnosticWarn" },
        [vim.diagnostic.severity.INFO] = { " ", "DiagnosticInfo" },
        [vim.diagnostic.severity.HINT] = { "󰌵 ", "DiagnosticHint" },
      }

      local icon, hl = unpack(icon_map[diagnostic.severity] or { "", "" })
      local icon_str = (hl ~= "" and ("%#" .. hl .. "#" .. icon .. "%* ") or icon)

      local source = diagnostic.source or ""
      if source:match("typescript") or source:match("ts") or source:match("vtsls") then
        local artistic = format_ts_artistic(diagnostic)
        if artistic then
          return icon_str .. "\n" .. artistic
        end

        local ok, formatter = pcall(require, "format-ts-errors")
        if ok and diagnostic.code then
          local format_func = formatter[diagnostic.code]
          if format_func and type(format_func) == "function" then
            local msg = format_func(diagnostic.message)
            if msg and msg ~= "" then
              msg = msg:gsub("```typescript\n", ""):gsub("```ts\n", ""):gsub("\n```", "")
              return icon_str .. "\n" .. msg
            end
          end
        end
      end

      return icon_str .. diagnostic.message
    end,
  },
})

-- 3. Add highlight for subtle italic suffix (C2)
vim.api.nvim_set_hl(0, "DiagnosticHintItalic", { link = "DiagnosticHint", italic = true })
