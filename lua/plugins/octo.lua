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
      default_remote = {"upstream", "origin"},
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
          direction = "DESC"
        }
      },
      pull_requests = {
        order_by = {
          field = "CREATED_AT",
          direction = "DESC"
        },
        always_select_remote_on_create = false
      },
      file_panel = {
        size = 10,
        use_icons = true
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
        }
      },
    })

    -- Pull Request management (git group)
    vim.keymap.set("n", "<leader>gPr", function()
      print("Creating PR...")
      vim.cmd("Octo pr create")
    end, { desc = "Create PR" })
    vim.keymap.set("n", "<leader>gPl", ":Octo pr list<CR>", { desc = "List PRs" })
    vim.keymap.set("n", "<leader>gPo", ":Octo pr<CR>", { desc = "Open Current PR" })
    vim.keymap.set("n", "<leader>gPs", ":Octo pr search<CR>", { desc = "Search PRs" })
    vim.keymap.set("n", "<leader>gPc", ":Octo pr checkout<CR>", { desc = "Checkout PR" })
    
    -- Alternative PR creation methods
    vim.keymap.set("n", "<leader>gPt", ":Octo pr create --template<CR>", { desc = "Create PR with Template" })
    vim.keymap.set("n", "<leader>gPd", ":Octo pr create --draft<CR>", { desc = "Create Draft PR" })
    
    -- Quick review shortcuts  
    vim.keymap.set("n", "<leader>gPv", ":Octo review start<CR>", { desc = "Start Review" })
    vim.keymap.set("n", "<leader>gPR", ":Octo review resume<CR>", { desc = "Resume Review" })
    vim.keymap.set("n", "<leader>gPa", ":Octo review submit approve<CR>", { desc = "Approve PR" })
    vim.keymap.set("n", "<leader>gPx", ":Octo review submit request_changes<CR>", { desc = "Request Changes" })
    vim.keymap.set("n", "<leader>gPf", ":Octo pr files<CR>", { desc = "View PR Files" })
    
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
    
    -- Manual PR creation using gh CLI
    vim.keymap.set("n", "<leader>gPm", function()
      local branch = vim.fn.system("git branch --show-current"):gsub("\n", "")
      local title = vim.fn.input("PR Title: ")
      if title and title ~= "" then
        local body = vim.fn.input("PR Body (optional): ")
        local cmd = string.format("gh pr create --title '%s' --body '%s' --head %s --base main", title, body, branch)
        local result = vim.fn.system(cmd)
        print("PR created: " .. result)
      end
    end, { desc = "Manual PR Creation" })
  end,
}
