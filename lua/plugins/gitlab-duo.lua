return {
  "https://gitlab.com/gitlab-org/editor-extensions/gitlab.vim.git",
  name = "gitlab-duo",
  event = { "BufReadPre", "BufNewFile" },
  ft = {
    "go",
    "javascript",
    "typescript",
    "python",
    "ruby",
    "lua",
    "rust",
    "c",
    "cpp",
    "java",
    "php",
  },
  cond = function()
    -- Check if glab is available or GITLAB_TOKEN is set
    if vim.env.GITLAB_TOKEN and vim.env.GITLAB_TOKEN ~= "" then
      return true
    end
    local glab_check = vim.fn.system("command -v glab 2>/dev/null")
    return glab_check ~= ""
  end,
  init = function()
    local function get_gitlab_token()
      if vim.env.GITLAB_TOKEN and vim.env.GITLAB_TOKEN ~= "" then
        return vim.env.GITLAB_TOKEN
      end
      local token = vim.fn.system("glab config get -h gitlab.com token 2>/dev/null"):gsub("%s+", "")
      if token ~= "" then
        return token
      end
      local auth_output = vim.fn.system("glab auth status -t 2>&1")
      token = auth_output:match("Token:%s*(%S+)")
      return token
    end

    local token = get_gitlab_token()
    if token then
      vim.env.GITLAB_TOKEN = token
    end
  end,
  opts = {
    statusline = {
      enabled = true,
    },
    code_suggestions = {
      auto_filetypes = {
        "go",
        "javascript",
        "typescript",
        "python",
        "ruby",
        "lua",
        "rust",
        "c",
        "cpp",
        "java",
        "php",
      },
      ghost_text = {
        enabled = true,
        toggle_enabled = "<C-h>",
        accept_suggestion = "<C-l>",
        clear_suggestions = "<C-k>",
        stream = true,
      },
    },
  },
}
