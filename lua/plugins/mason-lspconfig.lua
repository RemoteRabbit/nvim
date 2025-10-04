return {
  "williamboman/mason-lspconfig.nvim",
  config = function()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "pyright", -- Python
        "terraformls", -- Terraform
        "lua_ls", -- Lua
        "elixirls", -- Elixir
        "erlangls", -- Erlang (requires rebar3)
        "jsonls", -- JSON
        "yamlls", -- YAML
        "marksman", -- Markdown
        "bashls", -- Bash
      },
      handlers = {
        function(server_name)
          local capabilities = require("blink.cmp").get_lsp_capabilities()
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end,
        ["terraformls"] = function()
          require("lspconfig").terraformls.setup({
            capabilities = require("blink.cmp").get_lsp_capabilities(),
            settings = {
              terraformls = {
                ignoreSingleFileWarning = true,
                experimentalFeatures = {
                  validateOnSave = true,
                  prefillRequiredFields = true,
                  moduleVariableHints = true,
                },
                indexing = {
                  enabled = true,
                  ignorePaths = {
                    ".terraform/providers/**",
                    ".terraform/.terraform.lock.hcl",
                  },
                  modulePaths = {
                    ".terraform/modules/**",
                    "./modules/**",
                    "../modules/**",
                    "../../modules/**",
                    "./terraform-modules/**",
                    "../terraform-modules/**",
                  },
                },
                validation = {
                  enableEnhancedValidation = true,
                },
              },
            },
            on_attach = function(client, bufnr)
              -- Enable inlay hints for module variables
              if client.server_capabilities.inlayHintProvider then
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
              end

              -- Add keymap to show module info
              vim.keymap.set("n", "<leader>tV", function()
                -- Get current word under cursor
                local word = vim.fn.expand("<cword>")
                if word and word ~= "" then
                  vim.lsp.buf.hover()
                else
                  print("Place cursor on module name and try again")
                end
              end, { buffer = bufnr, desc = "Show Module Info" })
            end,
          })
        end,
      },
    })
  end,
}
