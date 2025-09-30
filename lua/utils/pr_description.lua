-- Shared PR/MR description generator for both GitHub (octo) and GitLab
local M = {}

-- Function to generate PR/MR description (adapted from octo config)
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

  -- Add commit stats
  table.insert(description, "---")
  table.insert(description, "")
  table.insert(description, "**Commits:** " .. total_commits)
  table.insert(description, "**Branch:** `" .. branch .. "`")
  table.insert(description, "**Base:** `" .. base_branch .. "`")

  return table.concat(description, "\n")
end

return M
