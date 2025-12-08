return {
  "olimorris/codecompanion.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    strategies = {
      chat = {
        adapter = "llama_server",
      },
      inline = {
        adapter = "llama_server",
      },
    },
    adapters = {
      http = {
        llama_server = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            name = "llama_server",
            env = {
              url = "http://127.0.0.1:8080",
              api_key = "sk-no-key-required", -- pragma: allowlist secret
            },
            schema = {
              model = {
                default = "local-model",
              },
              stream = {
                default = true,
              },
            },
            -- Disable Qwen3 thinking mode for cleaner inline responses
            parameters = {
              stop = { "<think>", "</think>" },
            },
          })
        end,
        -- DeepSeek R1 with reasoning support
        deepseek_local = function()
          return require("codecompanion.adapters").extend("deepseek", {
            name = "deepseek_local",
            env = {
              url = "http://127.0.0.1:8080",
              api_key = "sk-no-key-required", -- pragma: allowlist secret
            },
            schema = {
              model = {
                default = "local-model",
              },
            },
          })
        end,
      },
    },
  },
  keys = {
    { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle CodeCompanion Chat" },
    { "<leader>ca", "<cmd>CodeCompanionActions<cr>", desc = "CodeCompanion Actions" },
    { "<leader>ci", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "Inline CodeCompanion" },
  },
}
