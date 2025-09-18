return {
  "CopilotC-Nvim/CopilotChat.nvim",
  enabled = true,
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "zbirenbaum/copilot.lua" },
    { "nvim-telescope/telescope.nvim" },
  },
  build = "make tiktoken",
  opts = {
    debug = false,
    show_help = true,
    disable_extra_info = true,
    hide_system_prompt = false,
    auto_follow_cursor = true,
    window = {
      layout = "vertical",
      relative = "editor",
      border = "rounded",
    },
    selection = "buffer",
    prompts = {
      Commit = {
        prompt = "Write a commit message following Conventional Commits style for this change.",
        selection = "gitdiff",
      },
      CommitStaged = {
        prompt = "Generate a Conventional Commit message for the staged changes.",
        selection = "gitdiff",
      },
      Explain = {
        prompt = "Explain the following code in detail, what it does and why.",
        selection = "visual",
      },
      Refactor = {
        prompt = "Refactor the selected code to improve readability and efficiency.",
        selection = "visual",
      },
      BetterNaming = {
        prompt = "Suggest better variable and function names for the selected code.",
        selection = "visual",
      },
    },
  },
  config = function(_, opts)
    local chat = require("CopilotChat")
    chat.setup(opts)
    print("CopilotChat.nvim initialized") -- Debug to confirm loading

    local map = vim.keymap.set
    local opts_map = { noremap = true, silent = true }

    -- Main chat keymaps
    map("n", "<leader>cc", "<cmd>CopilotChatToggle<cr>", opts_map)
    map("n", "<leader>cco", "<cmd>CopilotChatOpen<cr>", opts_map)
    map("n", "<leader>ccc", "<cmd>CopilotChatClose<cr>", opts_map)
    map("n", "<leader>ccr", "<cmd>CopilotChatReset<cr>", opts_map)
    map("n", "<leader>ccs", "<cmd>CopilotChatSave session<cr>", opts_map)
    map("n", "<leader>ccl", "<cmd>CopilotChatLoad session<cr>", opts_map)
    map("n", "<leader>ccq", function()
      local input = vim.fn.input("Quick Chat: ")
      if input ~= "" then
        chat.ask(input)
      end
    end, opts_map)

    -- Visual mode keymaps
    map("v", "<leader>ccx", function()
      chat.ask("", { selection = "visual" })
    end, opts_map)
    map("n", "<leader>ccp", function()
      chat.select_prompt()
    end, opts_map)

    -- Submit inside chat buffer with Ctrl+Enter and preserve <C-f>
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "copilot-chat",
      callback = function()
        vim.keymap.set("i", "<C-Enter>", "<cmd>CopilotChatSubmit<cr>", { buffer = true, noremap = true, silent = true })
        -- Ensure <C-f> works in copilot-chat buffer
        vim.keymap.set("i", "<C-f>", function()
          local ok, suggestion = pcall(require, "copilot.suggestion")
          if not ok then
            print("Failed to load copilot.suggestion in CopilotChat")
            return "<C-f>"
          end
          if suggestion.is_visible() then
            print("Accepting suggestion in CopilotChat")
            return suggestion.accept()
          else
            print("No suggestion in CopilotChat")
            return "<C-f>"
          end
        end, { buffer = true, expr = true, noremap = true, silent = false })
      end,
    })
  end,
}
