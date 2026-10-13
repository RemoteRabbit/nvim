return {
  src = "https://github.com/emrearmagan/atlas.nvim",
  config = function()
    require("atlas").setup({
      ui = {
        picker = "snacks",
      },
      pulls = {
        default_merge_method = "squash",
        default_delete_source_branch = true,
        description = {
          include_diffstat = true,
        },
        diff = {
          review_panel = {
            hidden = false,
          },
          layout = "side-by-side",
          lsp = {
            enabled = true,
          },
          explorer = {
            hidden = true,
            show_commits = true,
          },
        },
        repo_config = {
          paths = {
            ["RemoteRabbit/*"] = "~/Projects/personal/*",
            ["RemoteRabbit/*"] = "~/Projects/*",
          },
        },
      },
      providers = {
        github = {
          views = {
            {
              name = "My PRs",
              key = "1",
              layout = "grouped", -- "compact", "grouped", or "plain"
              current_repo = true, -- Limit this view to the local repository.
              search = "author:@me sort:updated-desc",
            },
          },
          bookmarks = {
            key = "S", -- default
            label = "Search", -- default
            items = {
              ["Drafts"] = "is:pr is:draft author:@me",
              ["Recently merged"] = "is:pr is:merged author:@me sort:updated-desc",
              ["Review requested"] = "is:pr is:open review-requested:@me",
            },
          },
        },
      },
      keymaps = {
        ui = {
          submit = "<M-s>",
        },
      },
    })
  end,
}
