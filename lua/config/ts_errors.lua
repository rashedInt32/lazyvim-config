local M = {}

local function prettify_type(type_str)
  if not type_str then
    return type_str
  end
  type_str = type_str:gsub('import%("[^"]+/node_modules/[^"]+"%)%.', "")
  type_str = type_str:gsub('import%("[^"]+"%)%.([%w_]+)', "%1")
  type_str = type_str:gsub("ParseResult%.", "")
  return type_str
end

local function format_type_multiline(type_str, indent)
  indent = indent or "│     "
  type_str = prettify_type(type_str)
  if not type_str then
    return {}
  end

  local max_line_len = 70

  -- Keep short types on a single line. Only break long ones.
  if #type_str <= max_line_len then
    return { type_str }
  end

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

function M.is_ts_source(source)
  source = source or ""
  return source:match("typescript") or source:match("ts") or source:match("vtsls")
end

-- Split a generic argument list at top-level commas, respecting nested
-- <>, [], (), {} depth. Example: "A, B<C, D>, E" -> { "A", "B<C, D>", "E" }.
local function split_generic_args(s)
  local parts = {}
  local depth = 0
  local current = ""
  for i = 1, #s do
    local c = s:sub(i, i)
    if c == "<" or c == "[" or c == "(" or c == "{" then
      depth = depth + 1
      current = current .. c
    elseif c == ">" or c == "]" or c == ")" or c == "}" then
      depth = depth - 1
      current = current .. c
    elseif c == "," and depth == 0 then
      table.insert(parts, vim.trim(current))
      current = ""
    else
      current = current .. c
    end
  end
  if #vim.trim(current) > 0 then
    table.insert(parts, vim.trim(current))
  end
  return parts
end

-- Strip common Effect-ecosystem noise so the type string matches our parsers.
local function clean_effect_string(s)
  if not s then
    return s
  end
  -- Effect.gen wraps yielded effects as YieldWrap<...> in errors.
  s = s:gsub("^YieldWrap<(.+)>$", "%1")
  -- Strip import path prefixes; keeps the suffix identifier.
  s = s:gsub('import%("[^"]+"%)%.', "")
  return vim.trim(s)
end

-- Parse Effect<A, E, R> / Stream<A, E, R> / Layer<ROut, E, RIn> and their
-- namespaced variants. Also accepts shorter 1- or 2-arg Effect signatures
-- (missing params default to `never`). Returns a shape with:
--   { tag = "effect"|"layer", A, E, R, labels = {"A","E","R"} }
local function parse_effect_type(s)
  if not s then
    return nil
  end
  s = clean_effect_string(s)

  local tag, inner
  inner = s:match("^Effect%.Effect<(.+)>$") or s:match("^Effect<(.+)>$")
  if inner then
    tag = "effect"
  else
    inner = s:match("^Stream%.Stream<(.+)>$") or s:match("^Stream<(.+)>$")
    if inner then
      tag = "stream"
    else
      inner = s:match("^Layer%.Layer<(.+)>$") or s:match("^Layer<(.+)>$")
      if inner then
        tag = "layer"
      end
    end
  end

  if not inner then
    return nil
  end

  local parts = split_generic_args(inner)
  local A, E, R = parts[1], parts[2] or "never", parts[3] or "never"
  if not A or A == "" then
    return nil
  end

  if tag == "layer" then
    return { tag = "layer", A = A, E = E, R = R, labels = { "ROut", "E", "RIn" } }
  end
  return { tag = tag, A = A, E = E, R = R, labels = { "A", "E", "R" } }
end

local function display_name(tag)
  if tag == "layer" then
    return "Layer"
  elseif tag == "stream" then
    return "Stream"
  end
  return "Effect"
end

-- Split a top-level union into its members, respecting generic/bracket depth.
local function split_union(s)
  local parts = {}
  local depth = 0
  local current = ""
  local i = 1
  while i <= #s do
    local c = s:sub(i, i)
    if c == "<" or c == "[" or c == "(" or c == "{" then
      depth = depth + 1
      current = current .. c
    elseif c == ">" or c == "]" or c == ")" or c == "}" then
      depth = depth - 1
      current = current .. c
    elseif c == "|" and depth == 0 then
      local t = vim.trim(current)
      if t ~= "" then
        table.insert(parts, t)
      end
      current = ""
    else
      current = current .. c
    end
    i = i + 1
  end
  local t = vim.trim(current)
  if t ~= "" then
    table.insert(parts, t)
  end
  return parts
end

local function has_scope(r)
  if not r then
    return false
  end
  for _, m in ipairs(split_union(r)) do
    if m == "Scope" or m == "Scope.Scope" then
      return true
    end
  end
  return false
end

-- Members of `a` that aren't in `b`. Both are top-level union strings.
local function union_diff(a, b)
  if not a or a == "never" then
    return {}
  end
  local b_set = {}
  if b and b ~= "never" then
    for _, part in ipairs(split_union(b)) do
      b_set[part] = true
    end
  end
  local missing = {}
  for _, part in ipairs(split_union(a)) do
    if not b_set[part] then
      table.insert(missing, part)
    end
  end
  return missing
end

-- Parse a TS diagnostic message into a structured kind + captures.
-- Returns nil if no pattern matched.
function M.parse(msg)
  -- TS often appends follow-up sentences after the core error; strip them so
  -- the `$`-anchored patterns below can still match.
  msg = msg
    :gsub("\n.*", "")
    :gsub("%.%s+Property.-$", "")
    :gsub(" with '[^']+': %w+%'.-$", "")
    :gsub(" with '[^']+'.-$", "")

  local got, expected = msg:match("Type '(.+)' is not assignable to type '(.+)'%.?$")
  if not got then
    got, expected = msg:match("Argument of type '(.+)' is not assignable to parameter of type '(.+)'%.?$")
  end

  if got then
    local got_eff = parse_effect_type(got)
    local exp_eff = parse_effect_type(expected)
    if got_eff and exp_eff and got_eff.tag == exp_eff.tag then
      local missing_services = union_diff(got_eff.R, exp_eff.R)
      local unhandled_errors = union_diff(got_eff.E, exp_eff.E)
      local success_differs = got_eff.A ~= exp_eff.A
      local scope_required = has_scope(got_eff.R) and not has_scope(exp_eff.R)
      local diff_count = 0
      if success_differs then
        diff_count = diff_count + 1
      end
      if got_eff.E ~= exp_eff.E then
        diff_count = diff_count + 1
      end
      if got_eff.R ~= exp_eff.R then
        diff_count = diff_count + 1
      end
      return {
        kind = "effect_mismatch",
        tag = got_eff.tag,
        labels = got_eff.labels,
        got = got_eff,
        expected = exp_eff,
        missing_services = missing_services,
        unhandled_errors = unhandled_errors,
        success_differs = success_differs,
        scope_required = scope_required,
        diff_count = diff_count,
      }
    end

    local missing_prop = msg:match("Property '([^']+)' is missing")
    return { kind = "type_mismatch", got = got, expected = expected, missing = missing_prop }
  end

  local prop, in_type, req_type = msg:match("Property '(.-)' is missing in type '(.-)' but required in type '(.-)'")
  if prop then
    return { kind = "missing_property", prop = prop, in_type = in_type, required = req_type }
  end

  local mp, on_type = msg:match("Property '(.-)' does not exist on type '(.-)'")
  if mp then
    return { kind = "unknown_property", prop = mp, on_type = on_type }
  end

  local name = msg:match("Cannot find name '(.-)'")
  if name then
    return { kind = "undefined", name = name }
  end

  local module_path = msg:match("Cannot find module '(.-)' or its corresponding type declarations")
    or msg:match("Cannot find module '(.-)'")
  if module_path then
    return { kind = "module_not_found", path = module_path }
  end

  local no_mod, no_mem = msg:match("Module '\"(.-)\"' has no exported member '(.-)'")
  if not no_mod then
    no_mod, no_mem = msg:match("Module '(.-)' has no exported member '(.-)'")
  end
  if no_mod then
    return { kind = "export_not_found", module = no_mod, member = no_mem }
  end

  local implicit = msg:match("Parameter '(.-)' implicitly has an 'any' type")
  if implicit then
    return { kind = "implicit_any", name = implicit }
  end

  local used_before = msg:match("Variable '(.-)' is used before being assigned")
  if used_before then
    return { kind = "used_before_assigned", name = used_before }
  end

  local nullish = msg:match("Object is possibly '(.-)'")
  if nullish then
    return { kind = "nullish", value = nullish }
  end

  local exp_args, got_args = msg:match("Expected (%d+) arguments?, but got (%d+)")
  if exp_args then
    return { kind = "arg_count", expected = exp_args, got = got_args }
  end

  local const_name = msg:match("Cannot assign to '(.-)' because it is a constant")
  if const_name then
    return { kind = "const_assign", name = const_name }
  end

  if msg:match("has no call signatures") then
    local t = msg:match("Type '(.-)' has no call signatures")
    return { kind = "not_callable", type = t }
  end

  local dep_sig, dep_name = msg:match("The signature '(.-)' of '(.-)' is deprecated")
  if dep_sig then
    return { kind = "deprecated", name = dep_name, signature = dep_sig }
  end
  local deprecated_name = msg:match("'(.-)' is deprecated")
  if deprecated_name then
    return { kind = "deprecated", name = deprecated_name }
  end

  return nil
end

function M.strip_fences(s)
  return (s:gsub("```typescript\n", ""):gsub("```ts\n", ""):gsub("\n```", ""))
end

-- Multi-line "artistic" renderer for the float.
function M.render_artistic(diagnostic)
  local msg = diagnostic.message
  local parsed = M.parse(msg)
  if not parsed then
    return nil
  end

  local lines = {}

  if parsed.kind == "effect_mismatch" then
    local g, e = parsed.got, parsed.expected
    local name = display_name(parsed.tag)
    local labels = parsed.labels
    local is_layer = parsed.tag == "layer"

    local function push_multiline(indent_prefix, first_prefix, value)
      local chunks = format_type_multiline(value, indent_prefix)
      table.insert(lines, first_prefix .. (chunks[1] or ""))
      for i = 2, #chunks do
        table.insert(lines, chunks[i])
      end
    end

    local function signature(shape)
      return display_name(shape.tag or parsed.tag)
        .. "<"
        .. shape.A
        .. ", "
        .. shape.E
        .. ", "
        .. shape.R
        .. ">"
    end

    local function push_signatures()
      local got_sig = signature(g)
      local exp_sig = signature(e)
      table.insert(lines, "│")
      push_multiline("│              ", "│  Got:      ", got_sig)
      push_multiline("│              ", "│  Expected: ", exp_sig)
    end

    -- Compact single-channel-diff mode: show only what actually differs.
    if parsed.diff_count == 1 then
      -- 1a. Requirements (R / RIn) missing.
      if #parsed.missing_services > 0 then
        local only_scope = #parsed.missing_services == 1 and parsed.missing_services[1]:match("^Scope")
        local title
        if only_scope then
          title = name .. " — Scope Required"
        elseif is_layer then
          title = name .. " — Missing RIn"
        else
          title = name .. " — Missing Services"
        end
        table.insert(lines, "╭─ ◈ " .. title)
        table.insert(lines, "│")
        table.insert(lines, "│  ◈ Forgot to provide: " .. table.concat(parsed.missing_services, " | "))
        if parsed.scope_required then
          table.insert(lines, "│  ⚡ Hint: wrap in Effect.scoped(...) — Scope is required")
        elseif is_layer then
          table.insert(lines, "│  ⚡ Hint: compose with Layer.provide(...) or Layer.merge(...)")
        else
          table.insert(lines, "│  ⚡ Hint: .pipe(Effect.provide(SomeLayer))")
        end
        push_signatures()
        table.insert(lines, "╰─")
        return table.concat(lines, "\n")
      end

      -- 1b. Errors unhandled in E channel.
      if #parsed.unhandled_errors > 0 then
        table.insert(lines, "╭─ ⚠ " .. name .. " — Unhandled Errors")
        table.insert(lines, "│")
        table.insert(lines, "│  ⚠ Not in E channel: " .. table.concat(parsed.unhandled_errors, " | "))
        table.insert(lines, "│  ⚡ Hint: .pipe(Effect.catchTags({...})) or Effect.orDie")
        push_signatures()
        table.insert(lines, "╰─")
        return table.concat(lines, "\n")
      end

      -- 1c. Success (A / ROut) channel mismatch.
      if parsed.success_differs then
        local a_label = labels[1]
        table.insert(lines, "╭─ ⊘ " .. name .. " — " .. a_label .. " Mismatch")
        table.insert(lines, "│")
        push_multiline("│              ", "│  ✗ Got " .. a_label .. ":    ", g.A)
        push_multiline("│              ", "│  ✓ Expected: ", e.A)
        push_signatures()
        table.insert(lines, "╰─")
        return table.concat(lines, "\n")
      end
    end

    -- Multi-channel diff: full tri-channel view.
    table.insert(lines, "╭─ ⊘ " .. name .. " Mismatch")
    table.insert(lines, "│")
    table.insert(lines, "│  ✗ Got:")
    push_multiline("│           ", "│     " .. labels[1] .. ": ", g.A)
    push_multiline("│           ", "│     " .. labels[2] .. ": ", g.E)
    push_multiline("│           ", "│     " .. labels[3] .. ": ", g.R)
    table.insert(lines, "│")
    table.insert(lines, "│  ✓ Expected:")
    push_multiline("│           ", "│     " .. labels[1] .. ": ", e.A)
    push_multiline("│           ", "│     " .. labels[2] .. ": ", e.E)
    push_multiline("│           ", "│     " .. labels[3] .. ": ", e.R)
    if #parsed.missing_services > 0 then
      table.insert(lines, "│")
      table.insert(lines, "│  ◈ Forgot to provide: " .. table.concat(parsed.missing_services, " | "))
    end
    if #parsed.unhandled_errors > 0 then
      table.insert(lines, "│  ⚠ Unhandled errors: " .. table.concat(parsed.unhandled_errors, " | "))
    end
    if parsed.scope_required then
      table.insert(lines, "│  ⚡ Hint: wrap in Effect.scoped(...)")
    end
    table.insert(lines, "╰─")
    return table.concat(lines, "\n")
  elseif parsed.kind == "type_mismatch" then
    local got_lines = format_type_multiline(parsed.got, "│              ")
    local expected_lines = format_type_multiline(parsed.expected, "│              ")
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
    local missing = parsed.missing or msg:match("Property '([^']+)' is missing")
    if missing then
      table.insert(lines, "│")
      table.insert(lines, "│  ◈ Missing:  '" .. missing .. "'")
    end
    table.insert(lines, "╰─")
    return table.concat(lines, "\n")
  elseif parsed.kind == "missing_property" then
    local in_lines = format_type_multiline(parsed.in_type, "│              ")
    local req_lines = format_type_multiline(parsed.required, "│              ")
    table.insert(lines, "╭─ ◈ Missing Property")
    table.insert(lines, "│")
    table.insert(lines, "│  ◈ Property:  '" .. parsed.prop .. "'")
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
  elseif parsed.kind == "unknown_property" then
    local on_lines = format_type_multiline(parsed.on_type, "│           ")
    table.insert(lines, "╭─ ❓ Unknown Property")
    table.insert(lines, "│")
    table.insert(lines, "│  ✗ '" .. parsed.prop .. "' not found")
    table.insert(lines, "│  ◇ on type: " .. (on_lines[1] or ""))
    for i = 2, #on_lines do
      table.insert(lines, on_lines[i])
    end
    table.insert(lines, "╰─")
    return table.concat(lines, "\n")
  elseif parsed.kind == "undefined" then
    return "╭─ ❓ Undefined Reference\n│\n│  ✗ '" .. parsed.name .. "' is not defined\n╰─"
  elseif parsed.kind == "module_not_found" then
    return "╭─ 🔗 Module Not Found\n│\n│  ✗ '" .. parsed.path .. "'\n│  ⚡ Check path or install types\n╰─"
  elseif parsed.kind == "export_not_found" then
    return ("╭─ 🔗 Export Not Found\n│\n│  ✗ '%s'\n│  ◇ not exported from '%s'\n╰─"):format(
      parsed.member,
      parsed.module:gsub(".*/", "")
    )
  elseif parsed.kind == "implicit_any" then
    return "╭─ 📝 Implicit Any\n│\n│  ⚠ '" .. parsed.name .. "' needs type annotation\n╰─"
  elseif parsed.kind == "used_before_assigned" then
    return "╭─ ⚠ Uninitialized Variable\n│\n│  ✗ '" .. parsed.name .. "' used before assignment\n╰─"
  elseif parsed.kind == "nullish" then
    return "╭─ ❓ Nullish Reference\n│\n│  ⚠ Object may be "
      .. parsed.value
      .. "\n│  ⚡ Add optional chaining (?.) or null check\n╰─"
  elseif parsed.kind == "arg_count" then
    return ("╭─ 🔢 Argument Count\n│\n│  ✗ Got %s args, expected %s\n╰─"):format(parsed.got, parsed.expected)
  elseif parsed.kind == "const_assign" then
    return "╭─ 🔒 Constant Assignment\n│\n│  ✗ '" .. parsed.name .. "' is readonly\n╰─"
  elseif parsed.kind == "deprecated" then
    return "╭─ ⚠ Deprecated\n│\n│  ⚠ '" .. parsed.name .. "' is deprecated\n╰─"
  elseif parsed.kind == "not_callable" then
    local type_lines = parsed.type and format_type_multiline(parsed.type, "│       ") or { "Expression" }
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

-- Short single-line renderer for inline virtual text.
function M.render_short(diagnostic)
  local msg = diagnostic.message
  local parsed = M.parse(msg)
  if not parsed then
    return nil
  end

  if parsed.kind == "effect_mismatch" then
    if parsed.scope_required and #parsed.missing_services == 1 and parsed.missing_services[1]:match("^Scope") then
      return "◈ Needs Effect.scoped"
    end
    if #parsed.missing_services > 0 then
      return "◈ Missing provide: " .. table.concat(parsed.missing_services, " | ")
    end
    if #parsed.unhandled_errors > 0 then
      return "⚠ Unhandled: " .. table.concat(parsed.unhandled_errors, " | ")
    end
    if parsed.success_differs then
      local label = parsed.labels[1]
      local g = parsed.got.A:sub(1, 30)
      local e = parsed.expected.A:sub(1, 30)
      if #parsed.got.A > 30 then g = g .. "…" end
      if #parsed.expected.A > 30 then e = e .. "…" end
      return "✗ " .. label .. ": " .. g .. " → ✓ " .. e
    end
    return "⊘ " .. display_name(parsed.tag) .. " mismatch"
  elseif parsed.kind == "type_mismatch" then
    local got = parsed.got:gsub("import%([^)]+%)%.", ""):sub(1, 50)
    local expected = parsed.expected:gsub("import%([^)]+%)%.", ""):sub(1, 50)
    if #parsed.got > 50 then
      got = got .. "…"
    end
    if #parsed.expected > 50 then
      expected = expected .. "…"
    end
    return "✗ " .. got .. " → ✓ " .. expected
  elseif parsed.kind == "missing_property" then
    return "◈ Missing: '" .. parsed.prop .. "'"
  elseif parsed.kind == "unknown_property" then
    return "✗ Unknown: '" .. parsed.prop .. "'"
  elseif parsed.kind == "undefined" then
    return "✗ Undefined: '" .. parsed.name .. "'"
  elseif parsed.kind == "module_not_found" then
    return "✗ Module: '" .. parsed.path:gsub(".*/", "") .. "'"
  elseif parsed.kind == "implicit_any" then
    return "⚠ Needs type: '" .. parsed.name .. "'"
  elseif parsed.kind == "nullish" then
    return "⚠ Possibly nullish"
  elseif parsed.kind == "deprecated" then
    return "⚠ Deprecated: '" .. parsed.name .. "'"
  end

  return nil
end

return M
