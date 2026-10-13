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
    -- Atlas has no hook for custom PR bodies, so wrap its description builder
    -- and swap in pr-description.nvim's output. Falls back to Atlas's body if
    -- pr-description fails (e.g. no commits ahead of base).
    local description = require("atlas.pulls.create.description")
    local build = description.build
    description.build = function(root, repo_slug, base, head, repository, on_done)
      return build(root, repo_slug, base, head, repository, function(content, err)
        if content then
          local body = require("pr-description").generate_description()
          if body then
            content.body = body
          end
        end
        on_done(content, err)
      end)
    end
  end,
}
