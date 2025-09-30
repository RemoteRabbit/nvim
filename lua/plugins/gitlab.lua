return {
  "harrisoncramer/gitlab.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "stevearc/dressing.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  build = function()
    require("gitlab.server").build(true)
  end,
  event = "VeryLazy",
  config = function()
    require("gitlab").setup({
      -- Authentication from git config first, then environment variables
      auth_provider = function()
        -- Try git config first
        local token = vim.fn.system("git config --get gitlab.token 2>/dev/null"):gsub("\n", "")
        local url = vim.fn.system("git config --get gitlab.url 2>/dev/null"):gsub("\n", "")

        -- Fall back to environment variables
        if token == "" then
          token = os.getenv("GITLAB_TOKEN")
        end
        if url == "" then
          url = os.getenv("GITLAB_URL") or "https://gitlab.com"
        end

        if not token or token == "" then
          vim.notify("GitLab token not found. Set with: git config --global gitlab.token <token>", vim.log.levels.WARN)
          return nil, nil, "No GitLab token found"
        end

        return token, url, nil
      end,
      log_path = vim.fn.stdpath("cache") .. "/gitlab.nvim.log",
      debug = { go_request = false, go_response = false },
    })

    -- Helper function to detect if current repo is GitLab
    local function is_gitlab_repo()
      local remote_url = vim.fn.system("git config --get remote.origin.url 2>/dev/null"):gsub("\n", "")
      return remote_url:match("gitlab") ~= nil
    end

    -- Context-aware keymaps that work with both GitHub (octo) and GitLab
    vim.keymap.set("n", "<leader>gPr", function()
      if is_gitlab_repo() then
        require("gitlab").create_mr()
      else
        vim.cmd("Octo pr create")
      end
    end, { desc = "Create PR/MR" })

    vim.keymap.set("n", "<leader>gPl", function()
      if is_gitlab_repo() then
        require("gitlab").choose_merge_request()
      else
        vim.cmd("Octo pr list")
      end
    end, { desc = "List PRs/MRs" })

    vim.keymap.set("n", "<leader>gPo", function()
      if is_gitlab_repo() then
        require("gitlab").review()
      else
        vim.cmd("Octo pr")
      end
    end, { desc = "Open Current PR/MR" })

    vim.keymap.set("n", "<leader>gPs", function()
      if is_gitlab_repo() then
        require("gitlab").choose_merge_request()
      else
        vim.cmd("Octo pr search")
      end
    end, { desc = "Search PRs/MRs" })

    vim.keymap.set("n", "<leader>gPc", function()
      if is_gitlab_repo() then
        require("gitlab").checkout_mr()
      else
        vim.cmd("Octo pr checkout")
      end
    end, { desc = "Checkout PR/MR" })

    -- Review shortcuts
    vim.keymap.set("n", "<leader>gPv", function()
      if is_gitlab_repo() then
        require("gitlab").review()
      else
        vim.cmd("Octo review start")
      end
    end, { desc = "Start Review" })

    vim.keymap.set("n", "<leader>gPR", function()
      if is_gitlab_repo() then
        require("gitlab").review()
      else
        vim.cmd("Octo review resume")
      end
    end, { desc = "Resume Review" })

    vim.keymap.set("n", "<leader>gPa", function()
      if is_gitlab_repo() then
        require("gitlab").approve()
      else
        vim.cmd("Octo review submit approve")
      end
    end, { desc = "Approve PR/MR" })

    vim.keymap.set("n", "<leader>gPx", function()
      if is_gitlab_repo() then
        require("gitlab").revoke()
      else
        vim.cmd("Octo review submit request_changes")
      end
    end, { desc = "Request Changes/Revoke" })

    vim.keymap.set("n", "<leader>gPf", function()
      if is_gitlab_repo() then
        require("gitlab").toggle_discussions()
      else
        vim.cmd("Octo pr files")
      end
    end, { desc = "View PR/MR Files" })

    -- Merge operations
    vim.keymap.set("n", "<leader>gPm", function()
      if is_gitlab_repo() then
        require("gitlab").merge()
      else
        vim.cmd("Octo pr merge")
      end
    end, { desc = "Merge PR/MR" })

    -- Issue management (if gitlab.nvim supports issues in future)
    -- For now, we'll create placeholders that open GitLab in browser
    vim.keymap.set("n", "<leader>gIl", function()
      local url = vim.fn.system("git config --get remote.origin.url"):gsub("\n", "")
      if url:match("gitlab") then
        local repo_url = url:gsub("%.git$", ""):gsub("git@", "https://"):gsub("gitlab%.com:", "gitlab.com/")
        vim.fn.system("xdg-open " .. repo_url .. "/-/issues 2>/dev/null &")
      else
        print("Not a GitLab repository")
      end
    end, { desc = "List Issues (Browser)" })
    vim.keymap.set("n", "<leader>gIn", function()
      local url = vim.fn.system("git config --get remote.origin.url"):gsub("\n", "")
      if url:match("gitlab") then
        local repo_url = url:gsub("%.git$", ""):gsub("git@", "https://"):gsub("gitlab%.com:", "gitlab.com/")
        vim.fn.system("xdg-open " .. repo_url .. "/-/issues/new 2>/dev/null &")
      else
        print("Not a GitLab repository")
      end
    end, { desc = "New Issue (Browser)" })

    -- Repository management
    vim.keymap.set("n", "<leader>gRb", function()
      local url = vim.fn.system("git config --get remote.origin.url"):gsub("\n", "")
      if url:match("gitlab") then
        local repo_url = url:gsub("%.git$", ""):gsub("git@", "https://"):gsub("gitlab%.com:", "gitlab.com/")
        vim.fn.system("xdg-open " .. repo_url .. " 2>/dev/null &")
      else
        print("Not a GitLab repository")
      end
    end, { desc = "Open Repo in Browser" })

    -- Pipeline management
    vim.keymap.set("n", "<leader>gPp", function()
      require("gitlab").pipeline()
    end, { desc = "View Pipeline" })

    -- Upload files
    vim.keymap.set("n", "<leader>gPu", function()
      require("gitlab").upload_file()
    end, { desc = "Upload File" })

    -- Toggle discussions
    vim.keymap.set("n", "<leader>gPd", function()
      require("gitlab").toggle_discussions()
    end, { desc = "Toggle Discussions" })

    -- Additional utilities
    vim.keymap.set("n", "<leader>gPb", function()
      require("gitlab").open_in_browser()
    end, { desc = "Open in Browser" })

    -- Create user commands for easier access
    vim.api.nvim_create_user_command("GitlabMR", function()
      require("gitlab").choose_merge_request()
    end, { desc = "Choose GitLab Merge Request" })

    vim.api.nvim_create_user_command("GitlabReview", function()
      require("gitlab").review()
    end, { desc = "Review Current MR" })

    vim.api.nvim_create_user_command("GitlabApprove", function()
      require("gitlab").approve()
    end, { desc = "Approve MR" })

    vim.api.nvim_create_user_command("GitlabMerge", function()
      require("gitlab").merge()
    end, { desc = "Merge MR" })

    vim.api.nvim_create_user_command("GitlabCreateMR", function()
      require("gitlab").create_mr()
    end, { desc = "Create MR" })

    vim.api.nvim_create_user_command("GitlabPipeline", function()
      require("gitlab").pipeline()
    end, { desc = "View Pipeline" })

    -- Print setup message
    vim.notify("GitLab.nvim loaded! Use :GitlabMR to get started", vim.log.levels.INFO)
  end,
}
