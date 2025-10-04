-- Go tools
return {
  {
    -- Go tools
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup({
        goimport = "gopls",
        gofmt = "gofumpt",
        max_line_len = 120,
        tag_transform = false,
        test_template = "",
        test_template_dir = "",
        comment_placeholder = "   ",
        lsp_cfg = true,
        lsp_gofumpt = true,
        lsp_on_attach = true,
        lsp_keymaps = true,
        lsp_codelens = true,
        diagnostic = {
          hdlr = false,
          underline = true,
          virtual_text = { space = 0, prefix = "" },
          signs = true,
          update_in_insert = false,
        },
        lsp_document_formatting = true,
        lsp_inlay_hints = {
          enable = true,
          only_current_line = false,
          only_current_line_autocmd = "CursorHold",
          show_variable_name = true,
          parameter_hints_prefix = "󰊕 ",
          show_parameter_hints = true,
          other_hints_prefix = "=> ",
        },
        trouble = true,
        test_runner = "go",
        verbose_tests = true,
        run_in_floaterm = false,
        luasnip = true,
        iferr_vertical_shift = 4,
      })

      -- Auto commands
      local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          require("go.format").goimport()
        end,
        group = format_sync_grp,
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>gsj", "<cmd>GoAddTag json<cr>", { desc = "Add JSON tags" })
      vim.keymap.set("n", "<leader>gsy", "<cmd>GoAddTag yaml<cr>", { desc = "Add YAML tags" })
      vim.keymap.set("n", "<leader>gsr", "<cmd>GoRMTag<cr>", { desc = "Remove tags" })
      vim.keymap.set("n", "<leader>gsf", "<cmd>GoFillStruct<cr>", { desc = "Fill struct" })
      vim.keymap.set("n", "<leader>gse", "<cmd>GoIfErr<cr>", { desc = "Add if err" })
      vim.keymap.set("n", "<leader>gch", "<cmd>GoCoverage<cr>", { desc = "Test coverage" })
      vim.keymap.set("n", "<leader>gcc", "<cmd>GoCoverageToggle<cr>", { desc = "Toggle coverage" })
      vim.keymap.set("n", "<leader>gcb", "<cmd>GoCoverageBrowser<cr>", { desc = "Coverage browser" })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
  },
}
