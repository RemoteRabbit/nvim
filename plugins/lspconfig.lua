return {
  src = "https://github.com/neovim/nvim-lspconfig",
  config = function()
    vim.lsp.log.set_level("WARN")

    -- Truncate LSP log if it exceeds 10 MB
    local log_path = vim.lsp.log.get_filename()
    local stat = vim.uv.fs_stat(log_path)
    if stat and stat.size > 10 * 1024 * 1024 then
      os.remove(log_path)
    end

    -- Blink.cmp stuff
    local lsp_capabilities = require("blink.cmp").get_lsp_capabilities()
    -- Apply blink capabilities to all LSP servers
    vim.lsp.config("*", {
      capabilities = lsp_capabilities,
    })

    -- Lua
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          telemetry = {
            enable = false,
          },
        },
      },
    })

    -- Custom configs (mason auto-enables installed servers via
    -- mason-lspconfig's automatic_enable; these are not mason-managed)
    vim.lsp.enable({
      "lsp-codelens",
      "lsp-inlay_hint",
      "lsp-inline_completion",
      "lsp-linked_editing_range",
    })

    -- Single LspAttach autocmd for all LSP-related setup
    vim.api.nvim_create_autocmd("LspAttach", {
      desc = "LSP actions",
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local bufnr = event.buf

        -- Enable inlay hints if supported
        if client and client:supports_method("textDocument/inlayHint") then
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

        -- Hover: LSP hover, falls back to diagnostic float if no hover info
        bufmap("n", "K", function()
          local has_diag = #vim.diagnostic.get(bufnr, { lnum = vim.fn.line(".") - 1 }) > 0
          local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/hover" })
          if #clients > 0 then
            vim.lsp.buf.hover({ border = "rounded" })
          elseif has_diag then
            vim.diagnostic.open_float({ border = "rounded" })
          end
        end, "Hover / diagnostic")

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
            if c:supports_method("textDocument/rename") then
              table.insert(capabilities, "rename")
            end
            if c:supports_method("textDocument/codeAction") then
              table.insert(capabilities, "code_action")
            end
            if c:supports_method("textDocument/hover") then
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
