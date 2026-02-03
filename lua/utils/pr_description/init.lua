---@module "utils.pr_description"
---@brief [[
--- Shared PR/MR description generator for both GitHub (octo) and GitLab.
---
--- This module generates well-formatted pull request or merge request descriptions
--- by analyzing git commits and file changes. It categorizes commits using
--- conventional commit patterns, links issues and tickets, and produces
--- markdown-formatted output suitable for GitHub PRs or GitLab MRs.
---
--- Usage:
---   local pr_desc = require("utils.pr_description")
---   local description, err = pr_desc.generate_description({ is_gitlab = false })
---
--- From CLI (headless):
---   nvim --headless -c "lua print(require('utils.pr_description').generate_description())" -c "qa"
---@brief ]]

local git = require("utils.pr_description.git")
local links = require("utils.pr_description.links")
local parser = require("utils.pr_description.parser")
local formatter = require("utils.pr_description.formatter")

---@class PrDescriptionOpts
---@field is_gitlab? boolean Whether this is a GitLab MR (default: false, auto-detected from remote)

local M = {}

---Generate a PR/MR description from the current branch's commits.
---
---Analyzes commits between the base branch and current branch, categorizes them
---using conventional commit patterns, and generates a markdown description with:
--- - Summary section (placeholder)
--- - Categorized commit sections (features, fixes, docs, etc.)
--- - File changes grouped by directory
--- - Statistics footer (files changed, insertions, deletions)
---
---@param opts? PrDescriptionOpts Options table
---@return string|nil description The generated markdown description, or nil on error
---@return string|nil error Error message if generation failed
function M.generate_description(opts)
  opts = opts or {}

  -- Validate git repository
  local ok, err = git.check_repo()
  if not ok then
    return nil, err
  end

  -- Get current branch
  local branch
  branch, err = git.get_current_branch()
  if not branch then
    return nil, err
  end

  -- Detect base branch
  local base_branch
  base_branch, err = git.detect_base_branch()
  if not base_branch then
    return nil, err
  end

  -- Parse remote URL and determine platform
  local remote_url = git.get_remote_url()
  local host, path = links.parse_remote_url(remote_url)
  local repo_url = links.build_repo_url(host, path)
  local is_gitlab = opts.is_gitlab or links.is_gitlab_host(host)

  -- Get commits
  local commit_lines
  commit_lines, err = git.get_commits(base_branch, branch)
  if not commit_lines then
    return nil, err
  end
  if #commit_lines == 0 then
    return nil, "No commits found ahead of " .. base_branch .. ". Make some commits first!"
  end

  -- Confirm if many commits
  if #commit_lines > 10 then
    print("Found " .. #commit_lines .. " commits - this seems like a lot for a single PR/MR.")
    print("This might include commits from other merged work.")
    local confirm = vim.fn.input("Continue anyway? (y/n): ")
    if confirm:lower() ~= "y" and confirm:lower() ~= "yes" then
      return nil, "Cancelled"
    end
  end

  -- Create link helper function
  local function process_links(subject, hash)
    if hash then
      return links.make_commit_link(hash, repo_url, is_gitlab)
    end
    return links.add_all_links(subject, repo_url, is_gitlab)
  end

  -- Parse commits into categories
  local categories = parser.parse_commits(commit_lines, process_links)

  -- Get file statistics
  local file_changes = git.get_file_changes(base_branch, branch)
  local file_stats_output = git.get_file_stats(base_branch, branch)
  local numstat_lines = git.get_file_numstat(base_branch, branch)

  -- Parse file data
  local file_stats = parser.parse_file_numstat(numstat_lines)
  local file_list = parser.parse_file_changes(file_changes)
  local total_files, total_insertions, total_deletions = parser.parse_total_stats(file_stats_output)

  -- Group files
  local file_groups = formatter.group_files(file_list, file_stats)

  -- Generate final description
  return formatter.generate(categories, file_groups, file_stats, {
    total_files = total_files,
    total_insertions = total_insertions,
    total_deletions = total_deletions,
    total_commits = #commit_lines,
    branch = branch,
    base_branch = base_branch,
  })
end

return M
