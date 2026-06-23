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
          completion = {
            enable = true,
            displayContext = 3,
          },
          hint = {
            enable = true,
          },
          runtime = {
            builtin = "enable",
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
            },
          },
        },
      },
    })

    -- Go
    vim.lsp.config("gopls", {
      settings = {
        gopls = {
          -- gopls disables the `test` codelens by default. Enabling it puts a
          -- runnable "run test"/"run benchmark" lens above each Test/Benchmark
          -- function in *_test.go files; trigger it with <leader>cl (run lens).
          codelenses = {
            test = true,
          },
        },
      },
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

        -- Code lens: always on. enable() attaches a provider that
        -- auto-refreshes as the buffer changes, so no manual keymap is needed.
        if client and client:supports_method("textDocument/codeLens") then
          vim.lsp.codelens.enable(true, { bufnr = bufnr })
        end

        -- Navigation
        vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Go to definition" })
        vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { desc = "Go to declaration" })
        vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", { desc = "Go to implementation" })
        vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { desc = "Go to type definition" })
        vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", { desc = "List references" })
        vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { desc = "Signature help" })

        -- Actions
        vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename symbol" })
        vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code action" })

        -- Hover: LSP hover, falls back to diagnostic float if no hover info
        vim.keymap.set("n", "K", function()
          local has_diag = #vim.diagnostic.get(bufnr, { lnum = vim.fn.line(".") - 1 }) > 0
          local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/hover" })
          if #clients > 0 then
            vim.lsp.buf.hover({ border = "rounded" })
          elseif has_diag then
            vim.diagnostic.open_float({ border = "rounded" })
          end
        end, { desc = "Hover / diagnostic" })

        -- Diagnostics
        vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Show diagnostics" })
        vim.keymap.set("n", "[d", function()
          vim.diagnostic.jump({ count = -1 })
        end, { desc = "Previous diagnostic" })
        vim.keymap.set("n", "]d", function()
          vim.diagnostic.jump({ count = 1 })
        end, { desc = "Next diagnostic" })

        -- Document symbols (outline view)
        vim.keymap.set("n", "<leader>ls", function()
          Snacks.picker.lsp_symbols()
        end, { desc = "Document symbols" })

        -- Workspace symbols (project-wide symbol search)
        vim.keymap.set("n", "<leader>lw", function()
          Snacks.picker.lsp_workspace_symbols()
        end, { desc = "Workspace symbols" })

        -- Code lens is refreshed automatically (see the codeLens autocmd
        -- above); <leader>cl runs the lens action under the cursor.
        vim.keymap.set("n", "<leader>cl", "<cmd>lua vim.lsp.codelens.run()<cr>", { desc = "Run code lens" })

        -- Debug LSP info
        vim.keymap.set("n", "<leader>li", function()
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
        end, { desc = "LSP info" })
      end,
    })
  end,
}
