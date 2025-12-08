-- Shared PR/MR description generator for both GitHub (octo) and GitLab
local M = {}

-- Function to generate PR/MR description (adapted from octo config)
-- @param opts table Options table
-- @param opts.is_gitlab boolean Whether this is a GitLab MR (default: false)
-- @return string|nil The generated description, or nil if cancelled/error
-- @return string|nil Error message if failed, or nil if successful
function M.generate_description(opts)
  opts = opts or {}
  local is_gitlab = opts.is_gitlab or false

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

  -- Get repo URL for commit links
  local remote_url = vim.fn.system("git config --get remote.origin.url"):gsub("\n", "")
  local repo_url = ""
  local repo_path = ""

  if is_gitlab and remote_url:match("gitlab") then
    -- Handle GitLab URLs
    repo_path = remote_url:gsub(".*gitlab%.[^:/]+[:/]", ""):gsub("%.git$", "")
    repo_url = remote_url:gsub("%.git$", ""):gsub("git@", "https://"):gsub("gitlab%.[^:]+:", "gitlab.com/")
  elseif remote_url:match("github%.com") then
    -- Handle GitHub URLs
    repo_path = remote_url:gsub(".*github%.com[:/]", ""):gsub("%.git$", "")
    repo_url = "https://github.com/" .. repo_path
  end

  -- Get commit subjects
  local git_cmd = "git log --oneline --no-merges " .. base_branch .. ".." .. branch
  local commit_subjects = vim.fn.systemlist(git_cmd)
  if #commit_subjects == 0 then
    return nil, "No commits found ahead of " .. base_branch .. ". Make some commits first!"
  end

  -- Ask user to confirm if there are many commits
  if #commit_subjects > 10 then
    print("Found " .. #commit_subjects .. " commits - this seems like a lot for a single PR/MR.")
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

  -- Helper function to add issue/PR links and tickets
  -- @param text string Text to process
  -- @return string Processed text with links
  local function add_links(text)
    if repo_path ~= "" then
      if is_gitlab then
        -- GitLab issue references
        text = text:gsub("(fixes?) #(%d+)", "%1 [#%2](" .. repo_url .. "/-/issues/%2)")
        text = text:gsub("(closes?) #(%d+)", "%1 [#%2](" .. repo_url .. "/-/issues/%2)")
        text = text:gsub("(resolves?) #(%d+)", "%1 [#%2](" .. repo_url .. "/-/issues/%2)")
      else
        -- GitHub issue/PR references
        text = text:gsub("(fixes?) #(%d+)", "%1 [#%2](" .. repo_url .. "/issues/%2)")
        text = text:gsub("(closes?) #(%d+)", "%1 [#%2](" .. repo_url .. "/issues/%2)")
        text = text:gsub("(resolves?) #(%d+)", "%1 [#%2](" .. repo_url .. "/issues/%2)")
      end
    end

    -- Replace Jira ticket references
    text = text:gsub("([A-Z][A-Z0-9]*%-[0-9]+)", function(ticket)
      return "[" .. ticket .. "](https://company.atlassian.net/browse/" .. ticket .. ")"
    end)

    return text
  end

  -- Parse commits into categories
  for _, commit in ipairs(commit_subjects) do
    local hash = commit:match("^(%S+)")
    local subject = commit:match("^%S+%s+(.*)")
    if not subject then
      subject = commit:gsub("^%S+%s*", "")
    end

    local commit_link = ""
    if repo_url ~= "" then
      if is_gitlab then
        commit_link = " [[" .. hash .. "]](" .. repo_url .. "/-/commit/" .. hash .. ")"
      else
        commit_link = " [[" .. hash .. "]](" .. repo_url .. "/commit/" .. hash .. ")"
      end
    end

    subject = add_links(subject)

    -- Categorize commits
    if subject:match("^feat[%(:]") or subject:match("^feature[%(:]") then
      table.insert(features, "- " .. subject .. commit_link)
    elseif subject:match("^fix[%(:]") or subject:match("^bugfix[%(:]") then
      table.insert(fixes, "- " .. subject .. commit_link)
    elseif subject:match("^docs?[%(:]") then
      table.insert(docs, "- " .. subject .. commit_link)
    elseif subject:match("^refactor[%(:]") then
      table.insert(refactor, "- " .. subject .. commit_link)
    elseif subject:match("^test[%(:]") or subject:match("^tests[%(:]") then
      table.insert(tests, "- " .. subject .. commit_link)
    elseif subject:match("^style[%(:]") or subject:match("^format[%(:]") then
      table.insert(style, "- " .. subject .. commit_link)
    elseif subject:match("^chore[%(:]") or subject:match("^ci[%(:]") or subject:match("^build[%(:]") then
      table.insert(chores, "- " .. subject .. commit_link)
    elseif subject:match("^revert[%(:]") then
      table.insert(reverts, "- " .. subject .. commit_link)
    elseif subject:match("^wip[%(:]") then
      table.insert(wip, "- " .. subject .. commit_link)
    else
      table.insert(others, "- " .. subject .. commit_link)
    end

    -- Check for breaking changes
    if subject:match("BREAKING CHANGE") or subject:match("!:") then
      table.insert(breaking, "- " .. subject .. commit_link)
    end
  end

  -- Generate description
  local description = {}

  -- Add title section
  table.insert(description, "## Summary")
  table.insert(description, "")
  table.insert(description, "_Brief description of changes_")
  table.insert(description, "")

  -- Breaking changes first (most important)
  if #breaking > 0 then
    table.insert(description, "## ⚠️ Breaking Changes")
    for _, item in ipairs(breaking) do
      table.insert(description, item)
    end
    table.insert(description, "")
  end

  -- Features
  if #features > 0 then
    table.insert(description, "## ✨ Features")
    for _, item in ipairs(features) do
      table.insert(description, item)
    end
    table.insert(description, "")
  end

  -- Bug fixes
  if #fixes > 0 then
    table.insert(description, "## 🐛 Bug Fixes")
    for _, item in ipairs(fixes) do
      table.insert(description, item)
    end
    table.insert(description, "")
  end

  -- Documentation
  if #docs > 0 then
    table.insert(description, "## 📚 Documentation")
    for _, item in ipairs(docs) do
      table.insert(description, item)
    end
    table.insert(description, "")
  end

  -- Refactoring
  if #refactor > 0 then
    table.insert(description, "## 🔨 Refactoring")
    for _, item in ipairs(refactor) do
      table.insert(description, item)
    end
    table.insert(description, "")
  end

  -- Tests
  if #tests > 0 then
    table.insert(description, "## 🧪 Tests")
    for _, item in ipairs(tests) do
      table.insert(description, item)
    end
    table.insert(description, "")
  end

  -- Style/formatting
  if #style > 0 then
    table.insert(description, "## 💄 Style")
    for _, item in ipairs(style) do
      table.insert(description, item)
    end
    table.insert(description, "")
  end

  -- Chores
  if #chores > 0 then
    table.insert(description, "## 🔧 Maintenance")
    for _, item in ipairs(chores) do
      table.insert(description, item)
    end
    table.insert(description, "")
  end

  -- Other commits
  if #others > 0 then
    table.insert(description, "## 📦 Other Changes")
    for _, item in ipairs(others) do
      table.insert(description, item)
    end
    table.insert(description, "")
  end

  -- WIP (usually last)
  if #wip > 0 then
    table.insert(description, "## 🚧 Work in Progress")
    for _, item in ipairs(wip) do
      table.insert(description, item)
    end
    table.insert(description, "")
  end

  -- Get file change statistics
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
      -- Handle formats like "38 insertions(+))" or just "38 insertions"
      total_insertions = tonumber(stats_line:match("(%d+) insertions?%(?%+?%)?")) or 0
      total_deletions = tonumber(stats_line:match("(%d+) deletions?%(?%-?%)?")) or 0
    end
  end

  -- Group files by directory
  local file_groups = {}
  local file_stats_detailed = {}

  if #file_changes > 0 then
    -- Get detailed file stats
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
    for _, change in ipairs(file_changes) do
      local status = change:sub(1, 1)
      local filepath = change:sub(3) -- Skip status and tab

      -- Determine group name
      local group_name = "Root"
      if filepath:match("^src/") or filepath:match("^lib/") then
        local parts = vim.split(filepath, "/")
        if #parts > 1 then
          group_name = parts[2]:gsub("^%l", string.upper) -- Capitalize first letter
        end
      elseif filepath:match("^test") or filepath:match("_test%.") or filepath:match("%.test%.") then
        group_name = "Tests"
      elseif filepath:match("^doc") or filepath:match("README") or filepath:match("%.md$") then
        group_name = "Documentation"
      elseif filepath:match("^config") or filepath:match("%.config%.") then
        group_name = "Configuration"
      else
        local dir = filepath:match("^([^/]+)/")
        if dir then
          group_name = dir:gsub("^%l", string.upper)
        end
      end

      if not file_groups[group_name] then
        file_groups[group_name] = {}
      end

      -- Get status symbol
      local symbol = ""
      if status == "A" then
        symbol = " ✨"
      elseif status == "M" then
        symbol = " 📝"
      elseif status == "D" then
        symbol = " 🗑️"
      elseif status == "R" then
        symbol = " ↻"
      end

      -- Get detailed stats for this file
      local stats = file_stats_detailed[filepath]
      local stats_str = ""
      if stats then
        if stats.insertions > 0 and stats.deletions > 0 then
          stats_str = string.format(" (+%d/-%d)", stats.insertions, stats.deletions)
        elseif stats.insertions > 0 then
          stats_str = string.format(" (+%d)", stats.insertions)
        elseif stats.deletions > 0 then
          stats_str = string.format(" (-%d)", stats.deletions)
        end
      end

      table.insert(file_groups[group_name], {
        path = filepath,
        symbol = symbol,
        stats = stats_str,
      })
    end

    -- Add file changes section
    if next(file_groups) then
      table.insert(description, "## 📁 File Changes")
      table.insert(description, "")

      -- Sort groups with priority order
      local priority_order = { "Root", "Src", "Lib", "Api", "Components", "Utils", "Config" }
      local sorted_groups = {}

      -- Add priority groups first
      for _, priority_group in ipairs(priority_order) do
        if file_groups[priority_group] then
          table.insert(sorted_groups, priority_group)
        end
      end

      -- Add remaining groups
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

      -- Sort non-priority groups alphabetically, but keep Tests and Documentation at end
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
            local stats = file_stats_detailed[file_info.path]
            if stats then
              group_insertions = group_insertions + stats.insertions
              group_deletions = group_deletions + stats.deletions
            end
          end

          table.insert(
            description,
            string.format("### %s (+%d/-%d lines)", group_name, group_insertions, group_deletions)
          )
          for _, file_info in ipairs(files) do
            table.insert(description, string.format("- `%s`%s%s", file_info.path, file_info.stats, file_info.symbol))
          end
          table.insert(description, "")
        end
      end
    end
  end

  -- Add commit and change stats
  table.insert(description, "---")
  table.insert(description, "")
  table.insert(
    description,
    "**Changes:** "
      .. total_files
      .. " files, +"
      .. total_insertions
      .. " insertions, -"
      .. total_deletions
      .. " deletions"
  )
  table.insert(description, "**Commits:** " .. total_commits)
  table.insert(description, "**Branch:** `" .. branch .. "`")
  table.insert(description, "**Base:** `" .. base_branch .. "`")

  return table.concat(description, "\n")
end

return M
