return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "saghen/blink.cmp",
  },
  config = function()
    local lsp_capabilities = require("blink.cmp").get_lsp_capabilities()

    -- Apply blink capabilities to all LSP servers
    vim.lsp.config("*", {
      capabilities = lsp_capabilities,
    })

    -- Lua language server configuration
    vim.lsp.config("lua_ls", {
      root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", ".git" },
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          diagnostics = {
            globals = {
              "love",
              "vim",
            },
          },
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
            },
          },
          telemetry = {
            enable = false,
          },
          completion = {
            callSnippet = "Replace",
          },
        },
      },
    })

    vim.lsp.enable("lua_ls")

    -- Diagnostic configuration
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.INFO] = " ",
          [vim.diagnostic.severity.HINT] = "󰌵 ",
        },
      },
      virtual_text = {
        prefix = "",
        spacing = 2,
      },
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        source = true,
        border = "rounded",
      },
    })

    -- Single LspAttach autocmd for all LSP-related setup
    vim.api.nvim_create_autocmd("LspAttach", {
      desc = "LSP actions",
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local bufnr = event.buf

        -- Enable inlay hints if supported
        if client and client.supports_method("textDocument/inlayHint") then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end

        local bufmap = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Navigation
        bufmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to definition")
        bufmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go to declaration")
        bufmap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", "Go to implementation")
        bufmap("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Go to type definition")
        bufmap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", "List references")
        bufmap("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature help")

        -- Actions
        bufmap("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename symbol")
        bufmap("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code action")

        -- Diagnostics
        bufmap("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", "Show diagnostics")
        bufmap("n", "[d", function()
          vim.diagnostic.jump({ count = -1 })
        end, "Previous diagnostic")
        bufmap("n", "]d", function()
          vim.diagnostic.jump({ count = 1 })
        end, "Next diagnostic")

        -- Document symbols (outline view)
        bufmap("n", "<leader>ls", function()
          Snacks.picker.lsp_symbols()
        end, "Document symbols")

        -- Workspace symbols (project-wide symbol search)
        bufmap("n", "<leader>lw", function()
          Snacks.picker.lsp_workspace_symbols()
        end, "Workspace symbols")

        -- Code lens
        bufmap("n", "<leader>cl", "<cmd>lua vim.lsp.codelens.run()<cr>", "Run code lens")
        bufmap("n", "<leader>cL", "<cmd>lua vim.lsp.codelens.refresh()<cr>", "Refresh code lens")

        -- Debug LSP info
        bufmap("n", "<leader>li", function()
          local clients = vim.lsp.get_clients({ bufnr = bufnr })
          if #clients == 0 then
            vim.notify("No LSP clients attached to this buffer", vim.log.levels.INFO)
            return
          end

          local info = {}
          for _, c in pairs(clients) do
            local capabilities = {}
            if c.supports_method("textDocument/rename") then
              table.insert(capabilities, "rename")
            end
            if c.supports_method("textDocument/codeAction") then
              table.insert(capabilities, "code_action")
            end
            if c.supports_method("textDocument/hover") then
              table.insert(capabilities, "hover")
            end

            table.insert(info, string.format("%s: %s", c.name, table.concat(capabilities, ", ")))
          end

          vim.notify("LSP Clients:\n" .. table.concat(info, "\n"), vim.log.levels.INFO)
        end, "LSP info")
      end,
    })
  end,
}
