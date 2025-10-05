return {
  "williamboman/mason-lspconfig.nvim",
  config = function()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "pyright",
        "ruff",
        "terraformls",
        "lua_ls",
        "elixirls",
        "erlangls",
        "jsonls",
        "yamlls",
        "marksman",
        "bashls",
        "dockerls",
      },
      handlers = {
        function(server_name)
          local capabilities = require("blink.cmp").get_lsp_capabilities()
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end,
        ["ruff_lsp"] = function()
          require("lspconfig").ruff_lsp.setup({
            capabilities = require("blink.cmp").get_lsp_capabilities(),
            init_options = {
              settings = {
                args = {
                  "--config=pyproject.toml",
                },
              },
            },
            on_attach = function(client, bufnr)
              client.server_capabilities.hoverProvider = false
              vim.keymap.set("n", "<leader>co", function()
                vim.lsp.buf.code_action({
                  context = { only = { "source.organizeImports" } },
                  apply = true,
                })
              end, { buffer = bufnr, desc = "Organize imports (ruff)" })
            end,
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
              if client.server_capabilities.inlayHintProvider then
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
              end

              vim.keymap.set("n", "<leader>tV", function()
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
