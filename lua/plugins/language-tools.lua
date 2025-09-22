-- Language-specific development tools
return {
  {
    -- Terraform tools
    "hashivim/vim-terraform",
    config = function()
      vim.g.terraform_align = 1
      vim.g.terraform_fmt_on_save = 1
    end,
  },
  {
    -- Python environment management
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
    config = function()
      require("venv-selector").setup({
        name = {
          "venv",
          ".venv",
          "env",
          ".env",
        },
        auto_refresh = false,
        search = true,
        dap_enabled = true,
        parents = 0,
        path = nil,
        stay_on_this_version = true,
        anaconda_base_path = "~/anaconda3",
        anaconda_envs_path = "~/anaconda3/envs",
        pyenv_path = "~/.pyenv/versions",
        fd_binary_name = "fd",
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>vs", "<cmd>VenvSelect<cr>", { desc = "Select Python environment" })
      vim.keymap.set("n", "<leader>vc", "<cmd>VenvSelectCached<cr>", { desc = "Select cached environment" })
    end,
  },
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
  {
    -- Elixir tools
    "elixir-tools/elixir-tools.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local elixir = require("elixir")
      local elixirls = require("elixir.elixirls")

      elixir.setup({
        nextls = {
          enable = true,
          init_options = {
            mix_env = "dev",
            mix_target = "host",
            experimental = {
              completions = {
                enable = true,
              },
            },
          },
        },
        credo = {
          enable = true,
        },
        elixirls = {
          enable = true,
          settings = elixirls.settings({
            dialyzerEnabled = false,
            enableTestLenses = false,
          }),
        },
        -- Disable lexical to avoid conflicts
        lexical = {
          enable = false,
        },
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    -- JSON tools
    "b0o/schemastore.nvim",
    config = function()
      -- This will be used by jsonls via lspconfig
    end,
  },
  {
    -- YAML tools
    "someone-stole-my-name/yaml-companion.nvim",
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("yaml-companion").setup({
        builtin_matchers = {
          kubernetes = { enabled = true },
          cloud_init = { enabled = true },
        },
        schemas = {
          {
            name = "Kubernetes",
            uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.22.0-standalone-strict/all.json",
          },
        },
        lspconfig = {
          flags = {
            debounce_text_changes = 150,
          },
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              validate = true,
              format = { enable = true },
              hover = true,
              schemaStore = {
                enable = true,
                url = "https://www.schemastore.org/api/json/catalog.json",
              },
              schemaDownload = { enable = true },
              schemas = {
                kubernetes = "*.yaml",
                ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
                ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
                ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
                ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "*gitlab-ci*.{yml,yaml}",
                ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
                ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
              },
              trace = { server = "debug" },
            },
          },
        },
      })

      -- Telescope integration
      require("telescope").load_extension("yaml_schema")

      -- Keymaps
      vim.keymap.set("n", "<leader>ys", "<cmd>Telescope yaml_schema<cr>", { desc = "YAML schema" })
    end,
  },
  {
    -- Enhanced JSON editing
    "gennaro-tedesco/nvim-jqx",
    ft = { "json", "yaml" },
    config = function()
      -- Keymaps
      vim.keymap.set("n", "<leader>jq", "<cmd>JqxList<cr>", { desc = "JQ query list" })
      vim.keymap.set("n", "<leader>jf", "<cmd>JqxQuery<cr>", { desc = "JQ query" })
    end,
  },
  {
    -- REST client
    "mistweaverco/kulala.nvim",
    config = function()
      require("kulala").setup({
        default_view = "body",
        default_env = "dev",
        debug = false,
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>rr", "<cmd>lua require('kulala').run()<cr>", { desc = "Run REST request" })
      vim.keymap.set("n", "<leader>rp", "<cmd>lua require('kulala').preview()<cr>", { desc = "Preview REST request" })
      vim.keymap.set(
        "n",
        "<leader>rl",
        "<cmd>lua require('kulala').replay()<cr>",
        { desc = "Replay last REST request" }
      )
      vim.keymap.set("n", "<leader>ri", "<cmd>lua require('kulala').inspect()<cr>", { desc = "Inspect REST request" })
    end,
  },
}
