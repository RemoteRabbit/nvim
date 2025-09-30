return {
  "pwntester/octo.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  event = "VeryLazy",
  config = function()
    require("octo").setup({
      default_remote = { "upstream", "origin" },
      default_merge_method = "squash",
      ssh_aliases = {},
      reaction_viewer_hint_icon = "",
      user_icon = " ",
      timeline_marker = "",
      timeline_indent = 2,
      right_bubble_delimiter = "",
      left_bubble_delimiter = "",
      github_hostname = "",
      snippet_context_lines = 4,
      gh_env = {},
      timeout = 5000,
      ui = {
        use_signcolumn = true,
        use_signstatus = true,
      },
      issues = {
        order_by = {
          field = "CREATED_AT",
          direction = "DESC",
        },
      },
      pull_requests = {
        order_by = {
          field = "CREATED_AT",
          direction = "DESC",
        },
        always_select_remote_on_create = false,
      },
      file_panel = {
        size = 10,
        use_icons = true,
      },
      mappings_disable_default = false,
      mappings = {
        issue = {
          close_issue = { lhs = "<space>ic", desc = "close issue" },
          reopen_issue = { lhs = "<space>io", desc = "reopen issue" },
          list_issues = { lhs = "<space>il", desc = "list open issues" },
          reload = { lhs = "<C-r>", desc = "reload issue" },
          open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
          copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
          add_assignee = { lhs = "<space>aa", desc = "add assignee" },
          remove_assignee = { lhs = "<space>ad", desc = "remove assignee" },
          create_label = { lhs = "<space>lc", desc = "create label" },
          add_label = { lhs = "<space>la", desc = "add label" },
          remove_label = { lhs = "<space>ld", desc = "remove label" },
          goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
          add_comment = { lhs = "<space>ca", desc = "add comment" },
          delete_comment = { lhs = "<space>cd", desc = "delete comment" },
          next_comment = { lhs = "]c", desc = "go to next comment" },
          prev_comment = { lhs = "[c", desc = "go to previous comment" },
          react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
          react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
          react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
          react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
          react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
          react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
          react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
          react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
        },
        pull_request = {
          checkout_pr = { lhs = "<space>po", desc = "checkout PR" },
          merge_pr = { lhs = "<space>pm", desc = "merge commit PR" },
          squash_and_merge_pr = { lhs = "<space>psm", desc = "squash and merge PR" },
          rebase_and_merge_pr = { lhs = "<space>prm", desc = "rebase and merge PR" },
          list_commits = { lhs = "<space>pc", desc = "list PR commits" },
          list_changed_files = { lhs = "<space>pf", desc = "list PR changed files" },
          show_pr_diff = { lhs = "<space>pd", desc = "show PR diff" },
          add_reviewer = { lhs = "<space>va", desc = "add reviewer" },
          remove_reviewer = { lhs = "<space>vd", desc = "remove reviewer request" },
          close_pr = { lhs = "<space>pic", desc = "close PR" },
          reopen_pr = { lhs = "<space>pio", desc = "reopen PR" },
          list_prs = { lhs = "<space>pl", desc = "list open PRs" },
          reload = { lhs = "<C-r>", desc = "reload PR" },
          open_in_browser = { lhs = "<C-b>", desc = "open PR in browser" },
          copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
          goto_file = { lhs = "gf", desc = "go to file" },
          add_assignee = { lhs = "<space>aa", desc = "add assignee" },
          remove_assignee = { lhs = "<space>ad", desc = "remove assignee" },
          create_label = { lhs = "<space>lc", desc = "create label" },
          add_label = { lhs = "<space>la", desc = "add label" },
          remove_label = { lhs = "<space>ld", desc = "remove label" },
          goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
          add_comment = { lhs = "<space>ca", desc = "add comment" },
          delete_comment = { lhs = "<space>cd", desc = "delete comment" },
          next_comment = { lhs = "]c", desc = "go to next comment" },
          prev_comment = { lhs = "[c", desc = "go to previous comment" },
          react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
          react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
          react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
          react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
          react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
          react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
          react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
          react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
          review_start = { lhs = "<space>vs", desc = "start a review for the current PR" },
          review_resume = { lhs = "<space>vr", desc = "resume a pending review for the current PR" },
        },
        review_thread = {
          goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
          add_comment = { lhs = "<space>ca", desc = "add comment" },
          add_suggestion = { lhs = "<space>sa", desc = "add suggestion" },
          delete_comment = { lhs = "<space>cd", desc = "delete comment" },
          next_comment = { lhs = "]c", desc = "go to next comment" },
          prev_comment = { lhs = "[c", desc = "go to previous comment" },
          select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
          react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
          react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
          react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
          react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
          react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
          react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
          react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
          react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
        },
        submit_win = {
          approve_review = { lhs = "<C-a>", desc = "approve review" },
          comment_review = { lhs = "<C-m>", desc = "comment review" },
          request_changes = { lhs = "<C-r>", desc = "request changes review" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
        },
        review_diff = {
          submit_review = { lhs = "<leader>vs", desc = "submit review" },
          discard_review = { lhs = "<leader>vd", desc = "discard review" },
          add_review_comment = { lhs = "<space>ca", desc = "add a new review comment" },
          add_review_suggestion = { lhs = "<space>sa", desc = "add a new review suggestion" },
          focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
          toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
          next_thread = { lhs = "]t", desc = "move to next thread" },
          prev_thread = { lhs = "[t", desc = "move to previous thread" },
          select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
          toggle_viewed = { lhs = "<leader><space>", desc = "toggle viewer viewed state" },
          goto_file = { lhs = "gf", desc = "go to file" },
        },
        file_panel = {
          submit_review = { lhs = "<leader>vs", desc = "submit review" },
          discard_review = { lhs = "<leader>vd", desc = "discard review" },
          next_entry = { lhs = "j", desc = "move to next changed file" },
          prev_entry = { lhs = "k", desc = "move to previous changed file" },
          select_entry = { lhs = "<cr>", desc = "show selected changed file diffs" },
          refresh_files = { lhs = "R", desc = "refresh changed files panel" },
          focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
          toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
          select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
          toggle_viewed = { lhs = "<leader><space>", desc = "toggle viewer viewed state" },
        },
      },
    })

    -- Note: Main PR keymaps moved to gitlab.lua for context-aware handling

    -- GitHub-specific PR creation methods (only available for GitHub)
    vim.keymap.set("n", "<leader>gPt", ":Octo pr create --template<CR>", { desc = "Create PR with Template" })
    vim.keymap.set("n", "<leader>gPd", ":Octo pr create --draft<CR>", { desc = "Create Draft PR" })

    -- Issue management
    vim.keymap.set("n", "<leader>gIl", ":Octo issue list<CR>", { desc = "List Issues" })
    vim.keymap.set("n", "<leader>gIn", ":Octo issue create<CR>", { desc = "New Issue" })
    vim.keymap.set("n", "<leader>gIo", ":Octo issue<CR>", { desc = "Open Issue" })
    vim.keymap.set("n", "<leader>gIs", ":Octo issue search<CR>", { desc = "Search Issues" })

    -- Repository management
    vim.keymap.set("n", "<leader>gRl", ":Octo repo list<CR>", { desc = "List Repos" })
    vim.keymap.set("n", "<leader>gRf", ":Octo repo fork<CR>", { desc = "Fork Repo" })
    vim.keymap.set("n", "<leader>gRb", ":Octo repo browser<CR>", { desc = "Open Repo in Browser" })

    -- Quick checkout (moved to avoid gco conflict)
    vim.keymap.set("n", "<leader>gCo", ":Octo pr checkout<CR>", { desc = "Checkout PR" })

    -- Function to generate PR description (shared by both gPg and gPm)
    local function generate_pr_description()
      local branch = vim.fn.system("git branch --show-current"):gsub("\n", "")

      -- Simple base branch detection
      local base_branch = "main" -- Start with most common

      -- Check if main exists, otherwise try master
      local main_exists = vim.fn.system("git show-ref --verify --quiet refs/heads/main 2>/dev/null")
      if vim.v.shell_error ~= 0 then
        local master_exists = vim.fn.system("git show-ref --verify --quiet refs/heads/master 2>/dev/null")
        if vim.v.shell_error == 0 then
          base_branch = "master"
        end
      end

      -- Get GitHub repo URL for commit links
      local remote_url = vim.fn.system("git config --get remote.origin.url"):gsub("\n", "")
      local github_repo = ""
      if remote_url:match("github%.com") then
        -- Handle both SSH and HTTPS formats
        github_repo = remote_url:gsub(".*github%.com[:/]", ""):gsub("%.git$", "")
      end

      -- Get commit subjects - simple approach that matches shell behavior
      local git_cmd = "git log --oneline --no-merges " .. base_branch .. ".." .. branch
      local commit_subjects = vim.fn.systemlist(git_cmd)
      if #commit_subjects == 0 then
        return nil, "No commits found ahead of " .. base_branch .. ". Make some commits first!"
      end

      -- Ask user to confirm if there are many commits
      if #commit_subjects > 10 then
        print("Found " .. #commit_subjects .. " commits - this seems like a lot for a single PR.")
        print("This might include commits from other merged work.")
        local confirm = vim.fn.input("Continue anyway? (y/n): ")
        if confirm:lower() ~= "y" and confirm:lower() ~= "yes" then
          return nil, "Cancelled"
        end
      end

      -- Parse conventional commits with descriptions
      local features, fixes, docs, refactor, tests, style, chores, reverts, wip, breaking, others =
        {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
      local total_commits = #commit_subjects

      -- Helper function to add issue/PR links and Jira tickets
      local function add_links(text)
        if github_repo ~= "" then
          -- Replace GitHub issue/PR references with links
          text = text:gsub("(fixes?) #(%d+)", "%1 [#%2](https://github.com/" .. github_repo .. "/issues/%2)")
          text = text:gsub("(closes?) #(%d+)", "%1 [#%2](https://github.com/" .. github_repo .. "/issues/%2)")
          text = text:gsub("(resolves?) #(%d+)", "%1 [#%2](https://github.com/" .. github_repo .. "/issues/%2)")
        end

        -- Replace Jira ticket references (common patterns)
        -- Matches patterns like: PROJ-123, ENG-456, TASK-789, etc.
        text = text:gsub("([A-Z][A-Z0-9]*%-[0-9]+)", function(ticket)
          -- You can customize this URL pattern for your organization
          -- Common patterns:
          -- Atlassian: https://company.atlassian.net/browse/TICKET
          -- Linear: https://linear.app/company/issue/TICKET
          return "[" .. ticket .. "](https://company.atlassian.net/browse/" .. ticket .. ")"
        end)

        return text
      end

      for _, line in ipairs(commit_subjects) do
        local hash, subject = line:match("(%S+)%s+(.*)")
        if subject then
          -- Filter out merge-like commits that slip through --no-merges
          local is_merge_like = subject:match("^[Mm]erge ")
            or subject:match("^[Mm]erged ")
            or subject:match("^[Mm]erge pull request")
            or subject:match("^[Mm]erge branch")
          if not is_merge_like then
            -- Get the full commit message for this hash
            local full_message = vim.fn.system("git log -1 --format='%s%n%b' " .. hash):gsub("\n$", "")
            local lines = vim.split(full_message, "\n")
            local commit_subject = lines[1] or subject
            local body_lines = {}
            local breaking_change = ""

            -- Process body lines
            for i = 2, #lines do
              local body_line = lines[i]
              if body_line and body_line ~= "" then
                if body_line:match("^BREAKING CHANGE:") then
                  breaking_change = body_line:match("^BREAKING CHANGE:%s*(.*)")
                else
                  table.insert(body_lines, body_line)
                end
              end
            end

            -- Enhanced breaking change detection (! syntax)
            local is_breaking = commit_subject:match("!:")
            if is_breaking and not breaking_change then
              breaking_change = "Breaking change in: " .. commit_subject:gsub("!:", ":")
            end

            local description = table.concat(body_lines, " "):gsub("%s+", " "):match("^%s*(.-)%s*$")

            -- Extract scope and type with enhanced detection
            local commit_type, scope, title = commit_subject:match("^(%w+)%(([^)]+)%)!?:%s*(.*)")
            if not commit_type then
              commit_type, title = commit_subject:match("^(%w+)!?:%s*(.*)")
              scope = nil
            end

            -- Special handling for revert commits
            if commit_subject:match("^[Rr]evert") then
              commit_type = "revert"
              title = commit_subject:match("^[Rr]evert:?%s*(.*)") or commit_subject
            -- Special handling for temporary commits
            elseif commit_subject:match("^[Tt]emp") or commit_subject:match("^[Tt]emporary") then
              commit_type = "temp"
              title = commit_subject:match("^[Tt]emp:?%s*(.*)")
                or commit_subject:match("^[Tt]emporary:?%s*(.*)")
                or commit_subject
            elseif not commit_type then
              commit_type = "other"
              title = commit_subject
            end

            -- Add links to title and description
            title = add_links(title or "")
            if description and description ~= "" then
              description = add_links(description)
            end

            local commit_link = ""
            if github_repo ~= "" then
              commit_link = " (["
                .. hash:sub(1, 7)
                .. "](https://github.com/"
                .. github_repo
                .. "/commit/"
                .. hash
                .. "))"
            end

            local main_entry = title .. commit_link
            local sub_entry = ""
            if description and description ~= "" then
              sub_entry = "  - " .. description
            end

            local full_entry = "- " .. main_entry
            if sub_entry ~= "" then
              full_entry = full_entry .. "\n" .. sub_entry
            end

            -- Categorize commits
            if commit_type == "feat" then
              table.insert(features, { entry = full_entry, scope = scope })
            elseif commit_type == "fix" then
              table.insert(fixes, { entry = full_entry, scope = scope })
            elseif commit_type == "docs" then
              table.insert(docs, { entry = full_entry, scope = scope })
            elseif commit_type == "refactor" then
              table.insert(refactor, { entry = full_entry, scope = scope })
            elseif commit_type == "test" then
              table.insert(tests, { entry = full_entry, scope = scope })
            elseif commit_type == "style" then
              table.insert(style, { entry = full_entry, scope = scope })
            elseif commit_type == "chore" then
              table.insert(chores, { entry = full_entry, scope = scope })
            elseif commit_type == "revert" then
              table.insert(reverts, { entry = full_entry, scope = scope })
            elseif commit_type == "temp" then
              table.insert(wip, { entry = full_entry, scope = scope }) -- Reuse wip array for temp
            else
              table.insert(others, { entry = full_entry, scope = scope })
            end

            if breaking_change and breaking_change ~= "" then
              table.insert(breaking, "- " .. add_links(breaking_change))
            end
          end -- close if not is_merge_like
        end
      end

      -- Helper function to group by scope
      local function group_by_scope(commits)
        local scoped = {}
        local unscoped = {}
        for _, commit in ipairs(commits) do
          if commit.scope then
            if not scoped[commit.scope] then
              scoped[commit.scope] = {}
            end
            table.insert(scoped[commit.scope], commit.entry)
          else
            table.insert(unscoped, commit.entry)
          end
        end
        return scoped, unscoped
      end

      -- Helper function to add section with scope grouping
      local function add_section(body_parts, title, commits, emoji)
        if #commits > 0 then
          table.insert(body_parts, "## " .. emoji .. " " .. title)
          local scoped, unscoped = group_by_scope(commits)

          -- Add unscoped commits first
          for _, entry in ipairs(unscoped) do
            table.insert(body_parts, entry)
          end

          -- Add scoped commits grouped by scope
          for scope, entries in pairs(scoped) do
            if #entries > 0 then
              table.insert(body_parts, "### " .. scope:upper())
              for _, entry in ipairs(entries) do
                table.insert(body_parts, entry)
              end
            end
          end
          table.insert(body_parts, "")
        end
      end

      -- Generate commit statistics summary
      local type_counts = {
        features = #features,
        fixes = #fixes,
        docs = #docs,
        refactor = #refactor,
        tests = #tests,
        style = #style,
        chores = #chores,
        reverts = #reverts,
        temp = #wip, -- Rename for clarity in summary
        others = #others,
      }

      local summary_parts = {}
      for type_name, count in pairs(type_counts) do
        if count > 0 then
          table.insert(summary_parts, count .. " " .. type_name)
        end
      end

      -- Get file changes - simple approach matching commit detection
      local file_changes = vim.fn.systemlist("git diff --name-status " .. base_branch .. ".." .. branch)
      local file_stats = vim.fn.system("git diff --stat " .. base_branch .. ".." .. branch)

      -- Parse file stats for total changes
      local total_files = 0
      local total_insertions = 0
      local total_deletions = 0
      local stats_line = "none"

      if file_stats and file_stats ~= "" then
        -- Split into lines and get the last line that has content
        local lines = vim.split(file_stats, "\n")
        for i = #lines, 1, -1 do
          local line = lines[i]:match("^%s*(.-)%s*$") -- trim whitespace
          if line and line ~= "" and line:match("files? changed") then
            stats_line = line
            break
          end
        end

        if stats_line and stats_line ~= "none" then
          total_files = tonumber(stats_line:match("(%d+) files? changed")) or 0
          -- Handle formats like "38 insertions(+)" or just "38 insertions"
          total_insertions = tonumber(stats_line:match("(%d+) insertions?%(?%+?%)?")) or 0
          total_deletions = tonumber(stats_line:match("(%d+) deletions?%(?%-?%)?")) or 0
        end
      end

      -- Group files by directory
      local file_groups = {}
      local file_stats_detailed = {}

      if #file_changes > 0 then
        -- Get detailed file stats - simple approach matching commit detection
        local detailed_stats = vim.fn.systemlist("git diff --numstat " .. base_branch .. ".." .. branch)
        for _, line in ipairs(detailed_stats) do
          local insertions, deletions, filepath = line:match("(%S+)%s+(%S+)%s+(.+)")
          if filepath then
            file_stats_detailed[filepath] = {
              insertions = insertions == "-" and 0 or tonumber(insertions) or 0,
              deletions = deletions == "-" and 0 or tonumber(deletions) or 0,
            }
          end
        end

        -- Group files by directory with intelligent module detection
        for _, line in ipairs(file_changes) do
          local status, filepath = line:match("(%S)%s+(.+)")
          if filepath then
            local parts = vim.split(filepath, "/")
            local group_name = parts[1] or "Root"

            -- Handle special cases first
            if
              filepath:match("_test%.")
              or filepath:match("%.test%.")
              or filepath:match("_spec%.")
              or filepath:match("%.spec%.")
            then
              group_name = "Tests"
            elseif filepath:match("%.md$") or group_name == "docs" then
              group_name = "Documentation"
            else
              -- Look for "modules" anywhere in the path
              local modules_index = nil
              for i, part in ipairs(parts) do
                if part == "modules" then
                  modules_index = i
                  break
                end
              end

              if modules_index then
                -- Found modules directory - extract module name from path after it
                local module_parts = {}
                for i = modules_index + 1, #parts - 1 do -- Exclude filename
                  table.insert(module_parts, parts[i])
                end

                if #module_parts > 0 then
                  -- Use the deepest module directory as the name
                  local module_name = module_parts[#module_parts]:gsub("_", " "):gsub("(%l)(%w*)", function(a, b)
                    return string.upper(a) .. b
                  end)
                  group_name = module_name .. " Module"
                else
                  group_name = "Modules"
                end
              else
                -- Default: use top-level directory, capitalized
                group_name = group_name:gsub("^%l", string.upper)
              end
            end

            if not file_groups[group_name] then
              file_groups[group_name] = {}
            end

            local status_symbol = ""
            if status == "A" then
              status_symbol = " ✨ new"
            elseif status == "D" then
              status_symbol = " 🗑️ deleted"
            elseif status == "M" then
              status_symbol = ""
            elseif status == "R" then
              status_symbol = " 🔄 renamed"
            end

            local stats = file_stats_detailed[filepath] or { insertions = 0, deletions = 0 }
            local stats_text = ""
            if stats.insertions > 0 or stats.deletions > 0 then
              stats_text = string.format(" (+%d/-%d)", stats.insertions, stats.deletions)
            end

            table.insert(file_groups[group_name], {
              path = filepath,
              stats = stats_text,
              symbol = status_symbol,
            })
          end
        end
      end

      -- Generate PR body
      local body_parts = {}

      -- Add simplified summary
      if #summary_parts > 0 then
        local files_summary = ""
        if total_files > 0 then
          files_summary = string.format(" | %d files (+%d/-%d lines)", total_files, total_insertions, total_deletions)
        end
        table.insert(
          body_parts,
          "**📊 Summary:** "
            .. total_commits
            .. " commits across "
            .. table.concat(summary_parts, ", ")
            .. files_summary
        )
        table.insert(body_parts, "")
        table.insert(body_parts, "---")
        table.insert(body_parts, "")
      end

      -- Add sections in logical order
      add_section(body_parts, "Features", features, "✨")
      add_section(body_parts, "Bug Fixes", fixes, "🐛")
      add_section(body_parts, "Documentation", docs, "📚")
      add_section(body_parts, "Refactoring", refactor, "♻️")
      add_section(body_parts, "Tests", tests, "✅")
      add_section(body_parts, "Styling", style, "🎨")
      add_section(body_parts, "Chores", chores, "🔧")
      add_section(body_parts, "Reverts", reverts, "⏪")
      add_section(body_parts, "Temporary Changes", wip, "⏳")

      if #breaking > 0 then
        table.insert(body_parts, "## 💥 Breaking Changes")
        for _, brk in ipairs(breaking) do
          table.insert(body_parts, brk)
        end
        table.insert(body_parts, "")
      end

      add_section(body_parts, "Other Changes", others, "🔄")

      -- Add horizontal line before file changes section
      if total_files > 0 then
        table.insert(body_parts, "---")
        table.insert(body_parts, "")
        table.insert(
          body_parts,
          string.format(
            "## 📁 File Changes (%d files, +%d/-%d lines)",
            total_files,
            total_insertions,
            total_deletions
          )
        )

        -- Sort groups alphabetically, but put common ones first
        local priority_order = { "Tests", "Documentation", "Root" }
        local sorted_groups = {}

        -- Add priority groups first
        for _, group in ipairs(priority_order) do
          if file_groups[group] then
            table.insert(sorted_groups, group)
          end
        end

        -- Add remaining groups alphabetically
        for group_name, _ in pairs(file_groups) do
          local found = false
          for _, priority_group in ipairs(priority_order) do
            if group_name == priority_group then
              found = true
              break
            end
          end
          if not found then
            table.insert(sorted_groups, group_name)
          end
        end
        table.sort(sorted_groups, function(a, b)
          if a == "Tests" or a == "Documentation" or a == "Root" then
            return false
          end
          if b == "Tests" or b == "Documentation" or b == "Root" then
            return true
          end
          return a < b
        end)

        for _, group_name in ipairs(sorted_groups) do
          local files = file_groups[group_name]
          if files and #files > 0 then
            -- Calculate group totals
            local group_insertions = 0
            local group_deletions = 0
            for _, file_info in ipairs(files) do
              local filepath = file_info.path
              local stats = file_stats_detailed[filepath]
              if stats then
                group_insertions = group_insertions + stats.insertions
                group_deletions = group_deletions + stats.deletions
              end
            end

            table.insert(
              body_parts,
              string.format("### %s (+%d/-%d lines)", group_name, group_insertions, group_deletions)
            )
            for _, file_info in ipairs(files) do
              table.insert(body_parts, string.format("- `%s`%s%s", file_info.path, file_info.stats, file_info.symbol))
            end
          end
        end
        table.insert(body_parts, "")
      end

      return table.concat(body_parts, "\n"), nil
    end

    -- Smart PR creation using conventional commits
    vim.keymap.set("n", "<leader>gPm", function()
      local branch = vim.fn.system("git branch --show-current"):gsub("\n", "")
      print("Creating PR for branch: " .. branch)

      -- Generate PR description using shared function
      local pr_description, error_msg = generate_pr_description()
      if error_msg then
        print("❌ " .. error_msg)
        return
      end

      -- Check if branch is pushed to remote
      local remote_check = vim.fn.system("git ls-remote --heads origin " .. branch .. " 2>/dev/null")
      if remote_check == "" then
        print("Branch not pushed to remote. Pushing now...")
        local push_result = vim.fn.system("git push -u origin " .. branch)
        if vim.v.shell_error ~= 0 then
          print("❌ Failed to push branch:")
          print(push_result)
          return
        end
        print("✅ Branch pushed to remote")
      end

      local title = vim.fn.input("PR Title: ")
      if title and title ~= "" then
        -- Write body to temp file to avoid shell escaping issues
        local temp_file = "/tmp/pr_body_" .. os.time() .. ".md"
        local file = io.open(temp_file, "w")
        if file then
          file:write(pr_description)
          file:close()

          local cmd = string.format(
            'gh pr create --title "%s" --body-file "%s" --head %s --base main',
            title:gsub('"', '\\"'),
            temp_file,
            branch
          )
          print("Running: " .. cmd)

          local result = vim.fn.system(cmd)
          local exit_code = vim.v.shell_error

          -- Clean up temp file
          os.remove(temp_file)

          if exit_code == 0 then
            print("✅ PR created successfully!")
            print(result)
          else
            print("❌ PR creation failed:")
            print(result)
          end
        else
          print("❌ Failed to create temp file for PR body")
        end
      end
    end, { desc = "Smart PR Creation with Conventional Commits" })

    -- Generate PR description only (for external PR creation)
    vim.keymap.set("n", "<leader>gPg", function()
      local branch = vim.fn.system("git branch --show-current"):gsub("\n", "")
      print("Generating PR description for branch: " .. branch)

      -- Simple base branch detection
      local base_branch = "main" -- Start with most common

      -- Check if main exists, otherwise try master
      local main_exists = vim.fn.system("git show-ref --verify --quiet refs/heads/main 2>/dev/null")
      if vim.v.shell_error ~= 0 then
        local master_exists = vim.fn.system("git show-ref --verify --quiet refs/heads/master 2>/dev/null")
        if vim.v.shell_error == 0 then
          base_branch = "master"
        end
      end

      print("Using base branch: " .. base_branch)

      -- Get GitHub repo URL for commit links
      local remote_url = vim.fn.system("git config --get remote.origin.url"):gsub("\n", "")
      local github_repo = ""
      if remote_url:match("github%.com") then
        -- Handle both SSH and HTTPS formats
        github_repo = remote_url:gsub(".*github%.com[:/]", ""):gsub("%.git$", "")
      end

      -- Get commit subjects - simple approach that matches shell behavior
      local git_cmd = "git log --oneline --no-merges " .. base_branch .. ".." .. branch
      print("Running: " .. git_cmd)
      local commit_subjects = vim.fn.systemlist(git_cmd)
      print("Found " .. #commit_subjects .. " commits")

      -- Show first few commits for debugging
      for i = 1, math.min(3, #commit_subjects) do
        print("Commit " .. i .. ": " .. commit_subjects[i])
      end

      if #commit_subjects == 0 then
        print("No commits found ahead of " .. base_branch .. ". Make some commits first!")
        return
      end

      -- Ask user to confirm if there are many commits
      if #commit_subjects > 10 then
        print("Found " .. #commit_subjects .. " commits - this seems like a lot for a single PR.")
        print("This might include commits from other merged work.")
        local confirm = vim.fn.input("Continue anyway? (y/n): ")
        if confirm:lower() ~= "y" and confirm:lower() ~= "yes" then
          print("Cancelled")
          return
        end
      end

      -- Parse conventional commits with descriptions
      local features, fixes, docs, refactor, tests, style, chores, reverts, wip, breaking, others =
        {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
      local total_commits = #commit_subjects

      -- Helper function to add issue/PR links and Jira tickets
      local function add_links(text)
        if github_repo ~= "" then
          -- Replace GitHub issue/PR references with links
          text = text:gsub("(fixes?) #(%d+)", "%1 [#%2](https://github.com/" .. github_repo .. "/issues/%2)")
          text = text:gsub("(closes?) #(%d+)", "%1 [#%2](https://github.com/" .. github_repo .. "/issues/%2)")
          text = text:gsub("(resolves?) #(%d+)", "%1 [#%2](https://github.com/" .. github_repo .. "/issues/%2)")
        end

        -- Replace Jira ticket references (common patterns)
        -- Matches patterns like: PROJ-123, ENG-456, TASK-789, etc.
        text = text:gsub("([A-Z][A-Z0-9]*%-[0-9]+)", function(ticket)
          -- You can customize this URL pattern for your organization
          -- Common patterns:
          -- Atlassian: https://company.atlassian.net/browse/TICKET
          -- Linear: https://linear.app/company/issue/TICKET
          return "[" .. ticket .. "](https://company.atlassian.net/browse/" .. ticket .. ")"
        end)

        return text
      end

      for _, line in ipairs(commit_subjects) do
        local hash, subject = line:match("(%S+)%s+(.*)")
        if subject then
          -- Filter out merge-like commits that slip through --no-merges
          local is_merge_like = subject:match("^[Mm]erge ")
            or subject:match("^[Mm]erged ")
            or subject:match("^[Mm]erge pull request")
            or subject:match("^[Mm]erge branch")
          if not is_merge_like then
            -- Get the full commit message for this hash
            local full_message = vim.fn.system("git log -1 --format='%s%n%b' " .. hash):gsub("\n$", "")
            local lines = vim.split(full_message, "\n")
            local commit_subject = lines[1] or subject
            local body_lines = {}
            local breaking_change = ""

            -- Process body lines
            for i = 2, #lines do
              local body_line = lines[i]
              if body_line and body_line ~= "" then
                if body_line:match("^BREAKING CHANGE:") then
                  breaking_change = body_line:match("^BREAKING CHANGE:%s*(.*)")
                else
                  table.insert(body_lines, body_line)
                end
              end
            end

            -- Enhanced breaking change detection (! syntax)
            local is_breaking = commit_subject:match("!:")
            if is_breaking and not breaking_change then
              breaking_change = "Breaking change in: " .. commit_subject:gsub("!:", ":")
            end

            local description = table.concat(body_lines, " "):gsub("%s+", " "):match("^%s*(.-)%s*$")

            -- Extract scope and type with enhanced detection
            local commit_type, scope, title = commit_subject:match("^(%w+)%(([^)]+)%)!?:%s*(.*)")
            if not commit_type then
              commit_type, title = commit_subject:match("^(%w+)!?:%s*(.*)")
              scope = nil
            end

            -- Special handling for revert commits
            if commit_subject:match("^[Rr]evert") then
              commit_type = "revert"
              title = commit_subject:match("^[Rr]evert:?%s*(.*)") or commit_subject
            -- Special handling for temporary commits
            elseif commit_subject:match("^[Tt]emp") or commit_subject:match("^[Tt]emporary") then
              commit_type = "temp"
              title = commit_subject:match("^[Tt]emp:?%s*(.*)")
                or commit_subject:match("^[Tt]emporary:?%s*(.*)")
                or commit_subject
            elseif not commit_type then
              commit_type = "other"
              title = commit_subject
            end

            -- Add links to title and description
            title = add_links(title or "")
            if description and description ~= "" then
              description = add_links(description)
            end

            local commit_link = ""
            if github_repo ~= "" then
              commit_link = " (["
                .. hash:sub(1, 7)
                .. "](https://github.com/"
                .. github_repo
                .. "/commit/"
                .. hash
                .. "))"
            end

            local main_entry = title .. commit_link
            local sub_entry = ""
            if description and description ~= "" then
              sub_entry = "  - " .. description
            end

            local full_entry = "- " .. main_entry
            if sub_entry ~= "" then
              full_entry = full_entry .. "\n" .. sub_entry
            end

            -- Categorize commits
            if commit_type == "feat" then
              table.insert(features, { entry = full_entry, scope = scope })
            elseif commit_type == "fix" then
              table.insert(fixes, { entry = full_entry, scope = scope })
            elseif commit_type == "docs" then
              table.insert(docs, { entry = full_entry, scope = scope })
            elseif commit_type == "refactor" then
              table.insert(refactor, { entry = full_entry, scope = scope })
            elseif commit_type == "test" then
              table.insert(tests, { entry = full_entry, scope = scope })
            elseif commit_type == "style" then
              table.insert(style, { entry = full_entry, scope = scope })
            elseif commit_type == "chore" then
              table.insert(chores, { entry = full_entry, scope = scope })
            elseif commit_type == "revert" then
              table.insert(reverts, { entry = full_entry, scope = scope })
            elseif commit_type == "temp" then
              table.insert(wip, { entry = full_entry, scope = scope }) -- Reuse wip array for temp
            else
              table.insert(others, { entry = full_entry, scope = scope })
            end

            if breaking_change and breaking_change ~= "" then
              table.insert(breaking, "- " .. add_links(breaking_change))
            end
          end -- close if not is_merge_like
        end
      end

      -- Helper function to group by scope
      local function group_by_scope(commits)
        local scoped = {}
        local unscoped = {}
        for _, commit in ipairs(commits) do
          if commit.scope then
            if not scoped[commit.scope] then
              scoped[commit.scope] = {}
            end
            table.insert(scoped[commit.scope], commit.entry)
          else
            table.insert(unscoped, commit.entry)
          end
        end
        return scoped, unscoped
      end

      -- Helper function to add section with scope grouping
      local function add_section(body_parts, title, commits, emoji)
        if #commits > 0 then
          table.insert(body_parts, "## " .. emoji .. " " .. title)
          local scoped, unscoped = group_by_scope(commits)

          -- Add unscoped commits first
          for _, entry in ipairs(unscoped) do
            table.insert(body_parts, entry)
          end

          -- Add scoped commits grouped by scope
          for scope, entries in pairs(scoped) do
            if #entries > 0 then
              table.insert(body_parts, "### " .. scope:upper())
              for _, entry in ipairs(entries) do
                table.insert(body_parts, entry)
              end
            end
          end
          table.insert(body_parts, "")
        end
      end

      -- Generate commit statistics summary
      local type_counts = {
        features = #features,
        fixes = #fixes,
        docs = #docs,
        refactor = #refactor,
        tests = #tests,
        style = #style,
        chores = #chores,
        reverts = #reverts,
        temp = #wip, -- Rename for clarity in summary
        others = #others,
      }

      local summary_parts = {}
      for type_name, count in pairs(type_counts) do
        if count > 0 then
          table.insert(summary_parts, count .. " " .. type_name)
        end
      end

      -- Get file changes - simple approach matching commit detection
      local file_changes = vim.fn.systemlist("git diff --name-status " .. base_branch .. ".." .. branch)
      local file_stats = vim.fn.system("git diff --stat " .. base_branch .. ".." .. branch)

      -- Parse file stats for total changes
      local total_files = 0
      local total_insertions = 0
      local total_deletions = 0
      local stats_line = "none"

      if file_stats and file_stats ~= "" then
        -- Split into lines and get the last line that has content
        local lines = vim.split(file_stats, "\n")
        for i = #lines, 1, -1 do
          local line = lines[i]:match("^%s*(.-)%s*$") -- trim whitespace
          if line and line ~= "" and line:match("files? changed") then
            stats_line = line
            break
          end
        end

        if stats_line and stats_line ~= "none" then
          total_files = tonumber(stats_line:match("(%d+) files? changed")) or 0
          -- Handle formats like "38 insertions(+)" or just "38 insertions"
          total_insertions = tonumber(stats_line:match("(%d+) insertions?%(?%+?%)?")) or 0
          total_deletions = tonumber(stats_line:match("(%d+) deletions?%(?%-?%)?")) or 0
        end
      end

      -- Group files by directory
      local file_groups = {}
      local file_stats_detailed = {}

      if #file_changes > 0 then
        -- Get detailed file stats - simple approach matching commit detection
        local detailed_stats = vim.fn.systemlist("git diff --numstat " .. base_branch .. ".." .. branch)
        for _, line in ipairs(detailed_stats) do
          local insertions, deletions, filepath = line:match("(%S+)%s+(%S+)%s+(.+)")
          if filepath then
            file_stats_detailed[filepath] = {
              insertions = insertions == "-" and 0 or tonumber(insertions) or 0,
              deletions = deletions == "-" and 0 or tonumber(deletions) or 0,
            }
          end
        end

        -- Group files by directory with intelligent module detection
        for _, line in ipairs(file_changes) do
          local status, filepath = line:match("(%S)%s+(.+)")
          if filepath then
            local parts = vim.split(filepath, "/")
            local group_name = parts[1] or "Root"

            -- Handle special cases first
            if
              filepath:match("_test%.")
              or filepath:match("%.test%.")
              or filepath:match("_spec%.")
              or filepath:match("%.spec%.")
            then
              group_name = "Tests"
            elseif filepath:match("%.md$") or group_name == "docs" then
              group_name = "Documentation"
            else
              -- Look for "modules" anywhere in the path
              local modules_index = nil
              for i, part in ipairs(parts) do
                if part == "modules" then
                  modules_index = i
                  break
                end
              end

              if modules_index then
                -- Found modules directory - extract module name from path after it
                local module_parts = {}
                for i = modules_index + 1, #parts - 1 do -- Exclude filename
                  table.insert(module_parts, parts[i])
                end

                if #module_parts > 0 then
                  -- Use the deepest module directory as the name
                  local module_name = module_parts[#module_parts]:gsub("_", " "):gsub("(%l)(%w*)", function(a, b)
                    return string.upper(a) .. b
                  end)
                  group_name = module_name .. " Module"
                else
                  group_name = "Modules"
                end
              else
                -- Default: use top-level directory, capitalized
                group_name = group_name:gsub("^%l", string.upper)
              end
            end

            if not file_groups[group_name] then
              file_groups[group_name] = {}
            end

            local status_symbol = ""
            if status == "A" then
              status_symbol = " ✨ new"
            elseif status == "D" then
              status_symbol = " 🗑️ deleted"
            elseif status == "M" then
              status_symbol = ""
            elseif status == "R" then
              status_symbol = " 🔄 renamed"
            end

            local stats = file_stats_detailed[filepath] or { insertions = 0, deletions = 0 }
            local stats_text = ""
            if stats.insertions > 0 or stats.deletions > 0 then
              stats_text = string.format(" (+%d/-%d)", stats.insertions, stats.deletions)
            end

            table.insert(file_groups[group_name], {
              path = filepath,
              stats = stats_text,
              symbol = status_symbol,
            })
          end
        end
      end

      -- Generate PR body
      local body_parts = {}

      -- Add simplified summary
      if #summary_parts > 0 then
        local files_summary = ""
        if total_files > 0 then
          files_summary = string.format(" | %d files (+%d/-%d lines)", total_files, total_insertions, total_deletions)
        end
        table.insert(
          body_parts,
          "**📊 Summary:** "
            .. total_commits
            .. " commits across "
            .. table.concat(summary_parts, ", ")
            .. files_summary
        )
        table.insert(body_parts, "")
        table.insert(body_parts, "---")
        table.insert(body_parts, "")
      end

      -- Add sections in logical order
      add_section(body_parts, "Features", features, "✨")
      add_section(body_parts, "Bug Fixes", fixes, "🐛")
      add_section(body_parts, "Documentation", docs, "📚")
      add_section(body_parts, "Refactoring", refactor, "♻️")
      add_section(body_parts, "Tests", tests, "✅")
      add_section(body_parts, "Styling", style, "🎨")
      add_section(body_parts, "Chores", chores, "🔧")
      add_section(body_parts, "Reverts", reverts, "⏪")
      add_section(body_parts, "Temporary Changes", wip, "⏳")

      if #breaking > 0 then
        table.insert(body_parts, "## 💥 Breaking Changes")
        for _, brk in ipairs(breaking) do
          table.insert(body_parts, brk)
        end
        table.insert(body_parts, "")
      end

      add_section(body_parts, "Other Changes", others, "🔄")

      -- Add horizontal line before file changes section
      if total_files > 0 then
        table.insert(body_parts, "---")
        table.insert(body_parts, "")
        table.insert(
          body_parts,
          string.format(
            "## 📁 File Changes (%d files, +%d/-%d lines)",
            total_files,
            total_insertions,
            total_deletions
          )
        )

        -- Sort groups alphabetically, but put common ones first
        local priority_order = { "Tests", "Documentation", "Root" }
        local sorted_groups = {}

        -- Add priority groups first
        for _, group in ipairs(priority_order) do
          if file_groups[group] then
            table.insert(sorted_groups, group)
          end
        end

        -- Add remaining groups alphabetically
        for group_name, _ in pairs(file_groups) do
          local found = false
          for _, priority_group in ipairs(priority_order) do
            if group_name == priority_group then
              found = true
              break
            end
          end
          if not found then
            table.insert(sorted_groups, group_name)
          end
        end
        table.sort(sorted_groups, function(a, b)
          if a == "Tests" or a == "Documentation" or a == "Root" then
            return false
          end
          if b == "Tests" or b == "Documentation" or b == "Root" then
            return true
          end
          return a < b
        end)

        for _, group_name in ipairs(sorted_groups) do
          local files = file_groups[group_name]
          if files and #files > 0 then
            -- Calculate group totals
            local group_insertions = 0
            local group_deletions = 0
            for _, file_info in ipairs(files) do
              local filepath = file_info.path
              local stats = file_stats_detailed[filepath]
              if stats then
                group_insertions = group_insertions + stats.insertions
                group_deletions = group_deletions + stats.deletions
              end
            end

            table.insert(
              body_parts,
              string.format("### %s (+%d/-%d lines)", group_name, group_insertions, group_deletions)
            )
            for _, file_info in ipairs(files) do
              table.insert(body_parts, string.format("- `%s`%s%s", file_info.path, file_info.stats, file_info.symbol))
            end
          end
        end
        table.insert(body_parts, "")
      end

      local pr_description = table.concat(body_parts, "\n")

      -- Copy to system clipboard
      vim.fn.setreg("+", pr_description)
      vim.fn.setreg("*", pr_description) -- Also set selection register for X11

      print("✅ PR description generated and copied to clipboard!")
      print("\n" .. pr_description)
    end, { desc = "Generate PR Description (copy to clipboard)" })
  end,
}
