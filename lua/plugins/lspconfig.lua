return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "saghen/blink.cmp",
  },
  config = function()
    local lspconfig = require("lspconfig")
    local lsp_capabilities = require("blink.cmp").get_lsp_capabilities()
    -- Configure diagnostic signs (modern approach)
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.INFO] = " ",
          [vim.diagnostic.severity.HINT] = "󰌵 ",
        },
      },
    })

    vim.diagnostic.config({
      virtual_text = {
        prefix = "",
        spacing = 2,
      },
      signs = true,
      underline = true,
      update_in_insert = false,

      severity_sort = true,
      severity = {
        error = "Error",
        warn = "Warning",
        info = "Information",
        hint = "Hint",
      },

      float = {
        source = "always",
        border = "rounded",
        winblend = 10,
        max_width = 80,
      },
    })
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

    vim.lsp.handlers["textDocument/signatureHelp"] =
      vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

    -- LSP servers are configured via mason-lspconfig handlers
    -- No need for manual setup here

    vim.api.nvim_create_autocmd("LspAttach", {
      desc = "LSP actions",
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local bufnr = event.buf

        -- Enable inlay hints if supported
        if client and client.supports_method("textDocument/inlayHint") then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end

        -- Enable code lens if supported
        if client and client.supports_method("textDocument/codeLens") then
          vim.lsp.codelens.refresh()
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = bufnr,
            callback = vim.lsp.codelens.refresh,
          })
        end

        -- Disable semantic tokens to avoid errors
        if client and client.supports_method("textDocument/semanticTokens/full") then
          client.server_capabilities.semanticTokensProvider = nil
        end

        local bufmap = function(mode, lhs, rhs)
          local opts = { buffer = bufnr }
          vim.keymap.set(mode, lhs, rhs, opts)
        end

        -- Displays hover information about the symbol under the cursor
        bufmap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")

        -- Jump to the definition
        bufmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>")

        -- Jump to declaration
        bufmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>")

        -- Lists all the implementations for the symbol under the cursor
        bufmap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>")

        -- Jumps to the definition of the type symbol
        bufmap("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>")

        -- Lists all the references
        bufmap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>")

        -- Displays a function's signature information
        bufmap("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>")

        -- Renames all references to the symbol under the cursor
        bufmap("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>")

        -- Selects a code action available at the current cursor position
        bufmap("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>")

        -- Show diagnostics in a floating window
        bufmap("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>")

        -- Move to the previous diagnostic
        bufmap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")

        -- Move to the next diagnostic
        bufmap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")

        -- Toggle inlay hints
        bufmap("n", "<leader>h", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end)

        -- Document symbols (outline view)
        bufmap("n", "<leader>ds", "<cmd>Telescope lsp_document_symbols<cr>")

        -- Workspace symbols (project-wide symbol search)
        bufmap("n", "<leader>ws", "<cmd>Telescope lsp_workspace_symbols<cr>")

        -- Code lens run
        bufmap("n", "<leader>cl", "<cmd>lua vim.lsp.codelens.run()<cr>")

        -- Code lens refresh
        bufmap("n", "<leader>cr", "<cmd>lua vim.lsp.codelens.refresh()<cr>")

        -- Debug LSP info
        bufmap("n", "<leader>li", function()
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          if #clients == 0 then
            vim.notify("No LSP clients attached to this buffer", vim.log.levels.INFO)
            return
          end

          local info = {}
          for _, client in pairs(clients) do
            local capabilities = {}
            if client.supports_method("textDocument/rename") then
              table.insert(capabilities, "rename")
            end
            if client.supports_method("textDocument/codeAction") then
              table.insert(capabilities, "code_action")
            end
            if client.supports_method("textDocument/hover") then
              table.insert(capabilities, "hover")
            end

            table.insert(info, string.format("%s: %s", client.name, table.concat(capabilities, ", ")))
          end

          vim.notify("LSP Clients:\n" .. table.concat(info, "\n"), vim.log.levels.INFO)
        end)
      end,
    })
  end,
}
