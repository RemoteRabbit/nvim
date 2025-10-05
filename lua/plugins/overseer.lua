return {
  "stevearc/overseer.nvim",
  config = function()
    require("overseer").setup({
      templates = { "builtin" },
      strategy = {
        "toggleterm",
        direction = "horizontal",
        autos_croll = true,
        quit_on_exit = "success",
      },
      component_aliases = {
        default = {
          { "display_duration", detail_level = 2 },
          "on_output_summarize",
          "on_exit_set_status",
          "on_complete_notify",
          "on_complete_dispose",
        },
      },
      bundles = {
        autostart_on_load = true,
        save_task_opts = {
          bundleable = true,
        },
      },
      task_list = {
        direction = "bottom",
        min_height = 25,
        max_height = 25,
        default_detail = 1,
        bindings = {
          ["?"] = "ShowHelp",
          ["g?"] = "ShowHelp",
          ["<CR>"] = "RunAction",
          ["<C-e>"] = "Edit",
          ["o"] = "Open",
          ["<C-v>"] = "OpenVsplit",
          ["<C-s>"] = "OpenSplit",
          ["<C-f>"] = "OpenFloat",
          ["<C-q>"] = "OpenQuickFix",
          ["p"] = "TogglePreview",
          ["<C-l>"] = "IncreaseDetail",
          ["<C-h>"] = "DecreaseDetail",
          ["L"] = "IncreaseAllDetail",
          ["H"] = "DecreaseAllDetail",
          ["["] = "DecreaseWidth",
          ["]"] = "IncreaseWidth",
          ["{"] = "PrevTask",
          ["}"] = "NextTask",
          ["<C-k>"] = "ScrollOutputUp",
          ["<C-j>"] = "ScrollOutputDown",
          ["q"] = "Close",
        },
      },
    })

    -- Task templates
    require("overseer").register_template({
      name = "run_script",
      builder = function()
        local file = vim.fn.expand("%:p")
        local cmd = { file }
        if vim.bo.filetype == "python" then
          cmd = { "python", file }
        elseif vim.bo.filetype == "sh" then
          cmd = { "bash", file }
        end
        return {
          cmd = cmd,
          components = { { "on_output_quickfix", open = true }, "default" },
        }
      end,
      condition = {
        filetype = { "sh", "python", "javascript" },
      },
    })

    -- Terraform plan template
    require("overseer").register_template({
      name = "terraform_plan",
      builder = function()
        return {
          cmd = { "terraform", "plan" },
          components = { { "on_output_quickfix", open = true }, "default" },
          cwd = vim.fn.getcwd(),
        }
      end,
      condition = {
        callback = function()
          return vim.fn.filereadable("main.tf") == 1 or vim.fn.filereadable("terraform.tf") == 1
        end,
      },
    })

    -- Terraform apply template
    require("overseer").register_template({
      name = "terraform_apply",
      builder = function()
        return {
          cmd = { "terraform", "apply", "-auto-approve" },
          components = { { "on_output_quickfix", open = true }, "default" },
          cwd = vim.fn.getcwd(),
        }
      end,
      condition = {
        callback = function()
          return vim.fn.filereadable("main.tf") == 1 or vim.fn.filereadable("terraform.tf") == 1
        end,
      },
    })

    -- Python test template
    require("overseer").register_template({
      name = "pytest",
      builder = function()
        return {
          cmd = { "python", "-m", "pytest", "-v" },
          components = { { "on_output_quickfix", open = true }, "default" },
          cwd = vim.fn.getcwd(),
        }
      end,
      condition = {
        callback = function()
          return vim.fn.filereadable("pytest.ini") == 1 or vim.fn.filereadable("pyproject.toml") == 1
        end,
      },
    })

    -- Helper function to parse trivy output and set quickfix
    local function parse_trivy_output(lines)
      local qf_list = {}

      for _, line in ipairs(lines) do
        if line and line ~= "" then
          -- Simple approach: look for lines that contain file paths and issues
          if line:find("%.tf") or line:find("%.yaml") or line:find("%.yml") then
            local file = line:match("([^%s]+%.t?f?)") or line:match("([^%s]+%.ya?ml)")
            if file then
              table.insert(qf_list, {
                filename = vim.fn.fnamemodify(file, ":p"),
                lnum = 1,
                col = 1,
                text = line:gsub("^%s*", ""):gsub("%s+", " "),
                type = line:find("HIGH") and "E" or line:find("MEDIUM") and "W" or "I",
              })
            end
          end
        end
      end

      vim.fn.setqflist(qf_list, "r")
      if #qf_list > 0 then
        vim.cmd("copen")
      end
    end

    -- Helper function to parse tfsec output and set quickfix
    local function parse_tfsec_output(lines)
      local qf_list = {}

      for _, line in ipairs(lines) do
        if line and line ~= "" then
          -- Look for file paths with line numbers
          local file, lnum = line:match("([^%s:]+%.tf):?(%d*)")
          if file then
            table.insert(qf_list, {
              filename = vim.fn.fnamemodify(file, ":p"),
              lnum = tonumber(lnum) or 1,
              col = 1,
              text = line:gsub("^%s*", ""):gsub("%s+", " "),
              type = line:find("HIGH") and "E" or line:find("MEDIUM") and "W" or "I",
            })
          end
        end
      end

      vim.fn.setqflist(qf_list, "r")
      if #qf_list > 0 then
        vim.cmd("copen")
      end
    end

    -- Simple vim commands for security scans
    vim.api.nvim_create_user_command("TrivyScan", function()
      local cwd = vim.fn.getcwd()
      -- Use current buffer's directory if it's a file, otherwise use cwd
      local current_file = vim.fn.expand("%:p")
      if current_file and current_file ~= "" then
        cwd = vim.fn.fnamemodify(current_file, ":h")
      end
      local output = {}
      vim.fn.jobstart({ "trivy", "fs", "--format", "table", "." }, {
        cwd = cwd,
        stdout_buffered = true,
        on_stdout = function(_, data)
          if data then
            vim.list_extend(output, data)
          end
        end,
        on_exit = function(_, code)
          if #output > 0 then
            parse_trivy_output(output)
          end
        end,
      })
    end, {})

    vim.api.nvim_create_user_command("TfsecScan", function()
      local cwd = vim.fn.getcwd()
      -- Use current buffer's directory if it's a file, otherwise use cwd
      local current_file = vim.fn.expand("%:p")
      if current_file and current_file ~= "" then
        cwd = vim.fn.fnamemodify(current_file, ":h")
      end
      local output = {}
      vim.fn.jobstart({ "tfsec", ".", "--format", "default", "--no-color" }, {
        cwd = cwd,
        stdout_buffered = true,
        on_stdout = function(_, data)
          if data then
            vim.list_extend(output, data)
          end
        end,
        on_exit = function(_, code)
          if #output > 0 then
            parse_tfsec_output(output)
          end
        end,
      })
    end, {})

    vim.keymap.set("n", "<leader>rr", "<cmd>OverseerRun<cr>", { desc = "Run task" })
    vim.keymap.set("n", "<leader>rt", "<cmd>OverseerToggle<cr>", { desc = "Toggle task list" })
    vim.keymap.set("n", "<leader>ra", "<cmd>OverseerQuickAction<cr>", { desc = "Quick action" })
    vim.keymap.set("n", "<leader>rb", "<cmd>OverseerBuild<cr>", { desc = "Build task" })
    vim.keymap.set("n", "<leader>rc", "<cmd>OverseerClearCache<cr>", { desc = "Clear cache" })

    -- Security scanning shortcuts
    vim.keymap.set("n", "<leader>rst", "<cmd>TrivyScan<cr>", { desc = "Run trivy security scan" })
    vim.keymap.set("n", "<leader>rsf", "<cmd>TfsecScan<cr>", { desc = "Run tfsec Terraform scan" })

    -- Debug commands to see raw output
    vim.api.nvim_create_user_command("TrivyDebug", function()
      local cwd = vim.fn.getcwd()
      local current_file = vim.fn.expand("%:p")
      if current_file and current_file ~= "" then
        cwd = vim.fn.fnamemodify(current_file, ":h")
      end
      vim.cmd("cd " .. cwd)
      vim.cmd("term trivy fs --format table .")
    end, {})

    vim.api.nvim_create_user_command("TfsecDebug", function()
      local cwd = vim.fn.getcwd()
      local current_file = vim.fn.expand("%:p")
      if current_file and current_file ~= "" then
        cwd = vim.fn.fnamemodify(current_file, ":h")
      end
      vim.cmd("cd " .. cwd)
      vim.cmd("term tfsec . --format default --no-color")
    end, {})
  end,
}
