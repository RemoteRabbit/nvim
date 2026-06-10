return {
  "harrisoncramer/gitlab.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  branch = "main",
  build = function()
    require("gitlab.server").build(true)
  end,
  event = "VeryLazy",
  config = function()
    local git_repo = require("utils.git_repo")

    -- Resolve the GitLab instance URL. The Go server derives the
    -- namespace/project from the git remote itself, so we only need the host.
    -- Priority: explicit `git config gitlab.url` / $GITLAB_URL override, then
    -- the host parsed from the origin remote (handles self-hosted instances),
    -- then gitlab.com as a last resort.
    local function resolve_gitlab_url()
      local configured = git_repo.configured_gitlab_url()
      if configured ~= "" then
        return configured
      end
      return git_repo.gitlab_url_from_remote() or "https://gitlab.com"
    end

    -- gitlab.nvim's Go server uses a custom HTTP transport that does NOT honor
    -- the HTTPS_PROXY/HTTP_PROXY env vars on its own (unlike glab/gh). Behind a
    -- corporate proxy this makes every API call hang. Pass the proxy explicitly.
    local gitlab_proxy = git_repo.proxy_for_host(git_repo.host_from_remote(resolve_gitlab_url()))

    require("gitlab").setup({
      auth_provider = function()
        local url = resolve_gitlab_url()

        -- Prefer the token glab already uses for this host (single source of
        -- truth — avoids gitlab.nvim running with a stale/expired token).
        local token = git_repo.glab_token_for_host(git_repo.host_from_remote(url))

        if not token or token == "" then
          token = vim.fn.system("git config --get gitlab.token 2>/dev/null"):gsub("%s+", "")
        end

        if token == "" then
          token = os.getenv("GITLAB_TOKEN")
        end

        if not token or token == "" then
          vim.notify(
            "GitLab token not found. Authenticate with `glab auth login` or set `git config --global gitlab.token <token>`.",
            vim.log.levels.WARN
          )
          return nil, nil, "No GitLab token found"
        end

        return token, url, nil
      end,
      debug = {
        request = true, -- Requests to/from Go server
        response = true,
        gitlab_request = true, -- Requests to/from Gitlab
        gitlab_response = true,
      },
      connection_settings = {
        proxy = gitlab_proxy,
        insecure = false,
        remote = "origin",
      },
      create_mr = {
        delete_branch = true,
        squash = true,
        target = "main",
      },
      log_path = vim.fn.stdpath("cache") .. "/gitlab.nvim.log",
    })

    -- Helper function to detect if current repo is GitLab
    local is_gitlab_repo = require("utils.git_repo").is_gitlab

    -- Context-aware keymaps that work with both GitHub (octo) and GitLab
    vim.keymap.set("n", "<leader>gPr", function()
      if is_gitlab_repo() then
        -- Generate description first, then create MR
        local description, error = require("pr-description").generate_description({ is_gitlab = true })
        if error then
          print("Error generating description: " .. error)
          require("gitlab").create_mr() -- Fallback to basic creation
        elseif description then
          -- Copy description to clipboard for pasting into MR
          vim.fn.setreg("+", description)
          print("Generated MR description (copied to clipboard)")
          require("gitlab").create_mr()
        else
          require("gitlab").create_mr()
        end
      else
        -- Generate description for GitHub PR too
        local description, error = require("pr-description").generate_description({ is_gitlab = false })
        if error then
          print("Error generating description: " .. error)
          vim.cmd("Octo pr create") -- Fallback to basic creation
        elseif description then
          -- Copy description to clipboard for pasting into PR
          vim.fn.setreg("+", description)
          print("Generated PR description (copied to clipboard)")
          vim.cmd("Octo pr create")
        else
          vim.cmd("Octo pr create")
        end
      end
    end, { desc = "Create PR/MR with Generated Description" })

    -- Add description generator keymap for GitLab
    vim.keymap.set("n", "<leader>gPg", function()
      if is_gitlab_repo() then
        local description, error = require("pr-description").generate_description({ is_gitlab = true })
        if error then
          print("Error: " .. error)
        elseif description then
          -- Copy description to clipboard and show it
          vim.fn.setreg("+", description)
          vim.cmd("new")
          vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(description, "\n"))
          vim.bo.filetype = "markdown"
          vim.bo.buftype = "nofile"
          vim.bo.bufhidden = "wipe"
          print("Generated GitLab MR description (copied to clipboard)")
        end
      else
        local description, error = require("pr-description").generate_description({ is_gitlab = false })
        if error then
          print("Error: " .. error)
        elseif description then
          vim.fn.setreg("+", description)
          vim.fn.setreg("*", description)
          vim.cmd("new")
          vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(description, "\n"))
          vim.bo.filetype = "markdown"
          vim.bo.buftype = "nofile"
          vim.bo.bufhidden = "wipe"
          print("Generated PR description (copied to clipboard)")
        end
      end
    end, { desc = "Generate PR/MR Description" })

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
  end,
}
