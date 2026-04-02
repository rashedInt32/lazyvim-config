return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    local function eslint_parser(output)
      if not output or type(output) ~= "string" or output == "" then
        return {}
      end

      local decoded = vim.json.decode(output)
      if not decoded or not decoded[1] then
        return {}
      end

      local file_result = decoded[1]
      local messages = file_result.messages
      if not messages then
        return {}
      end

      local diagnostics = {}

      for _, msg in ipairs(messages) do
        if type(msg) ~= "table" then
          goto continue
        end

        local lnum = tonumber(msg.line)
        if not lnum or lnum < 1 then
          goto continue
        end

        lnum = lnum - 1

        local col = (tonumber(msg.column) or 1) - 1
        local end_lnum = (tonumber(msg.endLine) or lnum + 1) - 1
        local end_col = tonumber(msg.endColumn) or (col + 1)

        local severity = vim.diagnostic.severity.WARN
        if msg.severity and msg.severity >= 2 then
          severity = vim.diagnostic.severity.ERROR
        end

        local message = msg.message
        if type(message) ~= "string" or message == "" then
          goto continue
        end

        table.insert(diagnostics, {
          lnum = lnum,
          col = col,
          end_lnum = end_lnum,
          end_col = end_col,
          message = message,
          severity = severity,
        })

        ::continue::
      end

      return diagnostics
    end

    lint.linters_by_ft = {
      javascript = { "eslint" },
      javascriptreact = { "eslint" },
      typescript = { "eslint" },
      typescriptreact = { "eslint" },
      vue = { "eslint" },
      svelte = { "eslint" },
      jsx = { "eslint" },
      tsx = { "eslint" },
    }

    lint.linters.eslint = {
      cmd = function()
        local local_binary = vim.fn.fnamemodify('./node_modules/.bin/eslint', ':p')
        return vim.loop.fs_stat(local_binary) and local_binary or "npx"
      end,
      args = {
        "--format",
        "json",
        "--stdin",
        "--stdin-filename",
        function() return vim.api.nvim_buf_get_name(0) end,
        "--no-ignore",
      },
      stdin = true,
      stream = "stdout",
      parser = eslint_parser,
      ignore_exitcode = true,
    }

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "TextChanged", "InsertLeave" }, {
      callback = function()
        local ok, err = pcall(require("lint").try_lint)
        if not ok then
          vim.notify("lint error: " .. tostring(err), vim.log.levels.ERROR)
        end
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Run linting" })
  end,
}
