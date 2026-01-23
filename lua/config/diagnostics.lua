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

local function prettify_type(type_str)
  if not type_str then
    return type_str
  end

  type_str = type_str:gsub("import%([^)]+%)%.", ""):gsub("import%([^)]+%)", "ᴵ"):gsub("ParseResult%.", "")

  return type_str
end

local function format_type_multiline(type_str, indent)
  indent = indent or "│     "
  type_str = prettify_type(type_str)
  if not type_str then
    return {}
  end

  local max_line_len = 70
  local lines = {}
  local brace_depth = 0
  local current = ""

  for i = 1, #type_str do
    local char = type_str:sub(i, i)
    current = current .. char

    if char == "{" then
      brace_depth = brace_depth + 1
    elseif char == "}" then
      brace_depth = brace_depth - 1
    end

    if char == ";" and brace_depth == 1 then
      table.insert(lines, vim.trim(current))
      current = ""
    elseif #current >= max_line_len and char == " " then
      table.insert(lines, vim.trim(current))
      current = ""
    end
  end

  if #vim.trim(current) > 0 then
    table.insert(lines, vim.trim(current))
  end

  if #lines <= 1 then
    return { type_str }
  end

  local result = {}
  for idx, line in ipairs(lines) do
    if idx == 1 then
      table.insert(result, line)
    else
      table.insert(result, indent .. line)
    end
  end

  return result
end

local function format_ts_artistic(diagnostic)
  local msg = diagnostic.message
  local code = diagnostic.code
  local lines = {}

  local base_msg = msg
    :gsub("\n.*", "")
    :gsub("%.%s+Property.-$", "")
    :gsub(" with '[^']+': %w+%'.-$", "")
    :gsub(" with '[^']+'.-$", "")

  local got, expected = base_msg:match("Type '(.+)' is not assignable to type '(.+)'%.?$")
  if not got then
    got, expected = base_msg:match("Argument of type '(.+)' is not assignable to parameter of type '(.+)'%.?$")
  end

  if expected and got then
    local got_lines = format_type_multiline(got, "│              ")
    local expected_lines = format_type_multiline(expected, "│              ")
    table.insert(lines, "╭─ ⊘ Type Mismatch")
    table.insert(lines, "│")
    table.insert(lines, "│  ✗ Got:      " .. (got_lines[1] or ""))
    for i = 2, #got_lines do
      table.insert(lines, got_lines[i])
    end
    table.insert(lines, "│  ✓ Expected: " .. (expected_lines[1] or ""))
    for i = 2, #expected_lines do
      table.insert(lines, expected_lines[i])
    end

    local missing_prop = msg:match("Property '([^']+)' is missing")
    if missing_prop then
      table.insert(lines, "│")
      table.insert(lines, "│  ◈ Missing:  '" .. missing_prop .. "'")
    end

    table.insert(lines, "╰─")
    return table.concat(lines, "\n")
  end

  local prop, in_type, req_type = msg:match("Property '(.-)' is missing in type '(.-)' but required in type '(.-)'")
  if prop then
    local in_lines = format_type_multiline(in_type, "│              ")
    local req_lines = format_type_multiline(req_type, "│              ")
    table.insert(lines, "╭─ ◈ Missing Property")
    table.insert(lines, "│")
    table.insert(lines, "│  ◈ Property:  '" .. prop .. "'")
    table.insert(lines, "│  ◇ In:        " .. (in_lines[1] or ""))
    for i = 2, #in_lines do
      table.insert(lines, in_lines[i])
    end
    table.insert(lines, "│  ◆ Required:  " .. (req_lines[1] or ""))
    for i = 2, #req_lines do
      table.insert(lines, req_lines[i])
    end
    table.insert(lines, "╰─")
    return table.concat(lines, "\n")
  end

  local missing_prop, on_type = msg:match("Property '(.-)' does not exist on type '(.-)'")
  if missing_prop then
    local on_lines = format_type_multiline(on_type, "│           ")
    table.insert(lines, "╭─ ❓ Unknown Property")
    table.insert(lines, "│")
    table.insert(lines, "│  ✗ '" .. missing_prop .. "' not found")
    table.insert(lines, "│  ◇ on type: " .. (on_lines[1] or ""))
    for i = 2, #on_lines do
      table.insert(lines, on_lines[i])
    end
    table.insert(lines, "╰─")
    return table.concat(lines, "\n")
  end

  local name_not_found = msg:match("Cannot find name '(.-)'")
  if name_not_found then
    table.insert(lines, "╭─ ❓ Undefined Reference")
    table.insert(lines, "│")
    table.insert(lines, "│  ✗ '" .. name_not_found .. "' is not defined")
    table.insert(lines, "╰─")
    return table.concat(lines, "\n")
  end

  local module_path = msg:match("Cannot find module '(.-)' or its corresponding type declarations")
  if module_path then
    table.insert(lines, "╭─ 🔗 Module Not Found")
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
    table.insert(lines, "╭─ 🔗 Export Not Found")
    table.insert(lines, "│")
    table.insert(lines, "│  ✗ '" .. no_export_member .. "'")
    table.insert(lines, "│  ◇ not exported from '" .. no_export_module:gsub(".*/", "") .. "'")
    table.insert(lines, "╰─")
    return table.concat(lines, "\n")
  end

  local implicit_param = msg:match("Parameter '(.-)' implicitly has an 'any' type")
  if implicit_param then
    table.insert(lines, "╭─ 📝 Implicit Any")
    table.insert(lines, "│")
    table.insert(lines, "│  ⚠ '" .. implicit_param .. "' needs type annotation")
    table.insert(lines, "╰─")
    return table.concat(lines, "\n")
  end

  local var_used_before = msg:match("Variable '(.-)' is used before being assigned")
  if var_used_before then
    table.insert(lines, "╭─ ⚠ Uninitialized Variable")
    table.insert(lines, "│")
    table.insert(lines, "│  ✗ '" .. var_used_before .. "' used before assignment")
    table.insert(lines, "╰─")
    return table.concat(lines, "\n")
  end

  local obj_possibly = msg:match("Object is possibly '(.-)'")
  if obj_possibly then
    table.insert(lines, "╭─ ❓ Nullish Reference")
    table.insert(lines, "│")
    table.insert(lines, "│  ⚠ Object may be " .. obj_possibly)
    table.insert(lines, "│  ⚡ Add optional chaining (?.) or null check")
    table.insert(lines, "╰─")
    return table.concat(lines, "\n")
  end

  local expect_args, got_args = msg:match("Expected (%d+) arguments?, but got (%d+)")
  if expect_args then
    table.insert(lines, "╭─ 🔢 Argument Count")
    table.insert(lines, "│")
    table.insert(lines, "│  ✗ Got " .. got_args .. " args, expected " .. expect_args)
    table.insert(lines, "╰─")
    return table.concat(lines, "\n")
  end

  local const_name = msg:match("Cannot assign to '(.-)' because it is a constant")
  if const_name then
    table.insert(lines, "╭─ 🔒 Constant Assignment")
    table.insert(lines, "│")
    table.insert(lines, "│  ✗ '" .. const_name .. "' is readonly")
    table.insert(lines, "╰─")
    return table.concat(lines, "\n")
  end

  if msg:match("has no call signatures") then
    local type_name = msg:match("Type '(.-)' has no call signatures")
    local type_lines = type_name and format_type_multiline(type_name, "│       ") or { "Expression" }
    table.insert(lines, "╭─ ⊘ Not Callable")
    table.insert(lines, "│")
    table.insert(lines, "│  ✗ " .. (type_lines[1] or ""))
    for i = 2, #type_lines do
      table.insert(lines, type_lines[i])
    end
    table.insert(lines, "│    is not a function")
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
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.INFO] = " ",
        [vim.diagnostic.severity.HINT] = "󰌵 ",
      }

      local icon = icon_map[diagnostic.severity] or ""

      local source = diagnostic.source or ""
      if source:match("typescript") or source:match("ts") or source:match("vtsls") then
        local artistic = format_ts_artistic(diagnostic)
        if artistic then
          return icon .. "\n" .. artistic
        end

        local ok, formatter = pcall(require, "format-ts-errors")
        if ok and diagnostic.code then
          local format_func = formatter[diagnostic.code]
          if format_func and type(format_func) == "function" then
            local msg = format_func(diagnostic.message)
            if msg and msg ~= "" then
              msg = msg:gsub("```typescript\n", ""):gsub("```ts\n", ""):gsub("\n```", "")
              return icon .. "\n" .. msg
            end
          end
        end
      end

      return icon .. diagnostic.message
    end,
  },
})

vim.api.nvim_set_hl(0, "DiagnosticHintItalic", { link = "DiagnosticHint", italic = true })
