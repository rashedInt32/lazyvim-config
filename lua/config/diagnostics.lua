local pretty = require("effect-error-pretty")

local icons = {
  [vim.diagnostic.severity.ERROR] = " ",
  [vim.diagnostic.severity.WARN] = " ",
  [vim.diagnostic.severity.INFO] = " ",
  [vim.diagnostic.severity.HINT] = "󰌵 ",
}

-- Legacy sign_define path — reliable across all Neovim versions. The new
-- `signs.text` API below is kept as belt-and-suspenders.
local sign_names = { "Error", "Warn", "Info", "Hint" }
for i, name in ipairs(sign_names) do
  local hl = "DiagnosticSign" .. name
  vim.fn.sign_define(hl, { text = icons[i], texthl = hl, numhl = "" })
end

-- @effect/language-service tacks its rule name onto the end of the message
-- ("… Effect errors.    effect(missingEffectError)") and then reports code = 1,
-- which says nothing. Lift the rule into the code, where it belongs: the message
-- reads clean and the suffix becomes [missingEffectError] instead of [1].
local function normalize_effect_diagnostic(d)
  local rule = d.message and d.message:match("%s+effect%((%w+)%)%s*$")
  if rule then
    d.message = (d.message:gsub("%s+effect%(%w+%)%s*$", ""))
    d.code = rule
  end
  return d
end

-- @effect/language-service reports `missingEffectError` once per matching node,
-- so one missing error arrives as five byte-identical diagnostics at the same
-- range. Drop the copies as they come in — vtsls pushes diagnostics (it has no
-- diagnosticProvider), so publishDiagnostics is the funnel for all of them.
local function dedupe_lsp_diagnostics(diagnostics)
  local seen, out = {}, {}
  for _, d in ipairs(diagnostics) do
    local r = d.range or {}
    local s, e = r.start or {}, r["end"] or {}
    local key = table.concat({
      s.line or -1,
      s.character or -1,
      e.line or -1,
      e.character or -1,
      d.severity or 0,
      tostring(d.code),
      d.source or "",
      d.message or "",
    }, "\0")
    if not seen[key] then
      seen[key] = true
      out[#out + 1] = d
    end
  end
  return out
end

local original_publish = vim.lsp.handlers["textDocument/publishDiagnostics"]
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
  if result and result.diagnostics then
    -- Normalize before deduping: the dedupe key includes message and code, so
    -- the copies have to be identical by the time we compare them.
    result.diagnostics = dedupe_lsp_diagnostics(vim.tbl_map(normalize_effect_diagnostic, result.diagnostics))
  end
  return original_publish(err, result, ctx, config)
end

-- effect-error-pretty renders a multi-line box; anything vim.diagnostic splices
-- onto the first or last line (source prefix, code suffix) breaks its alignment.
local function is_box(rendered)
  return rendered:sub(1, #"╭") == "╭"
end

-- `suffix` runs *after* `format`, so by the time it is called the diagnostic's
-- message has already been replaced by the rendered box. Check that directly —
-- re-running float_format here would parse the box text and find nothing.
local function is_boxed(diagnostic)
  return is_box(diagnostic.message or "")
end

local function source_prefix(diagnostic)
  return diagnostic.source and (diagnostic.source .. ": ") or ""
end

local function apply_diagnostic_config()
  vim.diagnostic.config({
    update_in_insert = false,
    severity_sort = true,
    virtual_text = false,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = icons[vim.diagnostic.severity.ERROR],
        [vim.diagnostic.severity.WARN] = icons[vim.diagnostic.severity.WARN],
        [vim.diagnostic.severity.INFO] = icons[vim.diagnostic.severity.INFO],
        [vim.diagnostic.severity.HINT] = icons[vim.diagnostic.severity.HINT],
      },
    },
    underline = true,

    float = {
      border = "rounded",
      -- Deliberately off. open_float applies `format` first and only then
      -- prepends the source, so `source = true` shifts a rendered box's first
      -- line right by #"ts: " while leaving the gutter below it in place. The
      -- source is added back for plain messages in `format` instead.
      source = false,
      header = "",
      prefix = "",
      max_width = 100,

      suffix = function(diagnostic)
        -- Same story at the other end: a suffix lands after the box's `╰─`.
        if not diagnostic.code or is_boxed(diagnostic) then
          return "", ""
        end
        local sev_name = ({ "Error", "Warn", "Info", "Hint" })[diagnostic.severity] or "Hint"
        return string.format(" [%s]", diagnostic.code), "Diagnostic" .. sev_name .. "Italic"
      end,

      format = function(diagnostic)
        local icon = icons[diagnostic.severity] or ""
        local rendered = pretty.float_format(diagnostic)
        if not rendered then
          return icon .. source_prefix(diagnostic) .. diagnostic.message
        end
        -- Artistic boxes start with `╭` and render standalone; every other
        -- path is plain text that should carry the severity icon and source.
        if is_box(rendered) then
          return rendered
        end
        return icon .. source_prefix(diagnostic) .. rendered
      end,
    },
  })
end

apply_diagnostic_config()

-- LazyVim runs its own sign_define + vim.diagnostic.config during startup.
-- Re-apply ours on LazyVimStarted / VeryLazy to guarantee we win.
vim.api.nvim_create_autocmd("User", {
  pattern = { "LazyVimStarted", "VeryLazy" },
  callback = apply_diagnostic_config,
})

-- Subtle single-char background at the exact diagnostic column.
local ns = vim.api.nvim_create_namespace("diagnostic_inline_indicators")

local severity_name = { "Error", "Warn", "Info", "Hint" }

local function scale_rgb(rgb, factor)
  local r = math.floor(math.floor(rgb / 65536) % 256 * factor)
  local g = math.floor(math.floor(rgb / 256) % 256 * factor)
  local b = math.floor(rgb % 256 * factor)
  return string.format("#%02x%02x%02x", r, g, b)
end

local function setup_diagnostic_highlights()
  for _, name in ipairs(severity_name) do
    vim.api.nvim_set_hl(0, "Diagnostic" .. name .. "Italic", {
      link = "Diagnostic" .. name,
      italic = true,
    })

    local src = vim.api.nvim_get_hl(0, { name = "Diagnostic" .. name, link = false })
    local fg = src and src.fg
    if fg then
      local hex = scale_rgb(fg, 1.0)
      vim.api.nvim_set_hl(0, "DiagnosticUnderline" .. name, { undercurl = true, sp = hex })
      vim.api.nvim_set_hl(0, "DiagnosticSpotlight" .. name, { bg = scale_rgb(fg, 0.35) })
    end
  end

  -- Unused / deprecated: fade to a muted grey pulled from Comment fg.
  local comment = vim.api.nvim_get_hl(0, { name = "Comment", link = false })
  if comment and comment.fg then
    vim.api.nvim_set_hl(0, "DiagnosticSpotlightUnnecessary", { bg = scale_rgb(comment.fg, 0.35) })
  else
    vim.api.nvim_set_hl(0, "DiagnosticSpotlightUnnecessary", {})
  end
end

setup_diagnostic_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = setup_diagnostic_highlights,
})

local function has_tag(diagnostic, tag)
  if diagnostic._tags and diagnostic._tags[tag] then
    return true
  end
  local lsp_tags = diagnostic.user_data and diagnostic.user_data.lsp and diagnostic.user_data.lsp.tags
  if lsp_tags then
    -- LSP DiagnosticTag: 1 = Unnecessary, 2 = Deprecated
    local code = tag == "unnecessary" and 1 or (tag == "deprecated" and 2 or nil)
    if code then
      for _, t in ipairs(lsp_tags) do
        if t == code then
          return true
        end
      end
    end
  end
  return false
end

local function show_inline_indicators(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].buftype ~= "" then
    return
  end

  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  local diagnostics = vim.diagnostic.get(bufnr)
  local seen_positions = {}

  table.sort(diagnostics, function(a, b)
    return a.severity < b.severity
  end)

  local line_cache = {}
  for _, diagnostic in ipairs(diagnostics) do
    local hl_group
    if has_tag(diagnostic, "unnecessary") or has_tag(diagnostic, "deprecated") then
      hl_group = "DiagnosticSpotlightUnnecessary"
    else
      hl_group = "DiagnosticSpotlight" .. (severity_name[diagnostic.severity] or "Error")
    end
    local pos_key = diagnostic.lnum .. ":" .. diagnostic.col

    if not seen_positions[pos_key] then
      seen_positions[pos_key] = true

      local line = line_cache[diagnostic.lnum]
      if line == nil then
        line = vim.api.nvim_buf_get_lines(bufnr, diagnostic.lnum, diagnostic.lnum + 1, false)[1] or ""
        line_cache[diagnostic.lnum] = line
      end
      local line_len = #line

      if diagnostic.col < line_len then
        local end_col = math.min(diagnostic.col + 1, line_len)
        vim.api.nvim_buf_set_extmark(bufnr, ns, diagnostic.lnum, diagnostic.col, {
          end_col = end_col,
          hl_group = hl_group,
          priority = 100,
        })
      end
    end
  end
end

-- Debounce per-buffer so a flurry of DiagnosticChanged events during rapid
-- edits only triggers one redraw.
local pending = {}
vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function(args)
    local buf = args.buf
    if pending[buf] then
      return
    end
    pending[buf] = true
    vim.defer_fn(function()
      pending[buf] = nil
      show_inline_indicators(buf)
    end, 50)
  end,
})
