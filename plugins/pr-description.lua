-- INFO ========================================================================
-- Project Name: pr-description.nvim
-- Author: RemoteRabbit
-- URL: https://github.com/remoterabbit/pr-description.nvim
-- Description: Generate well-formatted PR/MR descriptions from your git commits.
-- Analyzes commits using conventional commit patterns, categorizes them, links
-- issues and Jira tickets, and produces markdown output for GitHub PRs or
-- GitLab MRs.
-- =============================================================================
-- ===============================Keymaps Start=================================
-- n <leader>gd Generate PR Description from commits.
-- =================================Keymaps End=================================

return {
  src = "https://github.com/remoterabbit/pr-description.nvim",
  config = function()
    require("pr-description").setup({
      foldable_file_changes = true,
    })
    vim.api.nvim_set_keymap(
      "n",
      "<leader>gd",
      ":PRDescription!<cr>",
      { desc = "Generate PR Description from commits." }
    )
  end,
}
