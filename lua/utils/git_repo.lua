-- Shared helpers for detecting the forge (GitHub vs GitLab) of the current repo.
local M = {}

--- Get the origin remote URL for the current repo.
---@return string
function M.remote_url()
  return vim.fn.system("git config --get remote.origin.url 2>/dev/null"):gsub("%s+", "")
end

--- The explicitly configured GitLab instance URL, if any
--- (`git config gitlab.url` or $GITLAB_URL). Empty string if unset.
---@return string
function M.configured_gitlab_url()
  local url = vim.fn.system("git config --get gitlab.url 2>/dev/null"):gsub("%s+", "")
  if url == "" then
    url = os.getenv("GITLAB_URL") or ""
  end
  return url
end

--- Whether the current repositories origin remote points at GitHub.
---@return boolean
function M.is_github()
  return M.remote_url():match("github") ~= nil
end

--- Whether the current repositories origin remote points at GitLab.
--- Matches the substring "gitlab", or for self-hosted instances on a
--- custom domain a host equal to the configured GitLab instance host.
---@return boolean
function M.is_gitlab()
  local remote = M.remote_url()
  if remote == "" or M.is_github() then
    return false
  end
  if remote:match("gitlab") then
    return true
  end
  local configured = M.configured_gitlab_url()
  if configured ~= "" then
    local configured_host = M.host_from_remote(configured)
    if configured_host and M.host_from_remote(remote) == configured_host then
      return true
    end
  end
  return false
end

--- Extract the host (e.g. "gitlab.example.com") from a git remote URL.
--- Handles HTTPS, ssh:// and git-style (git@host:group/repo.git) remotes.
---@param url string
---@return string|nil
function M.host_from_remote(url)
  if not url or url == "" then
    return nil
  end
  -- https://host/... or ssh://git@host[:port]/...
  local host = url:match("^https?://([^/]+)") or url:match("^ssh://[^@]*@?([^:/]+)")
  if not host then
    -- git-style: git@host:group/repo.git
    host = url:match("^[^@]+@([^:]+):")
  end
  if host then
    host = host:gsub(":%d+$", "") -- strip any :port
  end
  return host
end

--- Derive the GitLab instance base URL (e.g. "https://gitlab.example.com")
--- from the current repositories origin remote. Returns nil if no host can be parsed.
---@return string|nil
function M.gitlab_url_from_remote()
  local host = M.host_from_remote(M.remote_url())
  if not host then
    return nil
  end
  return "https://" .. host
end

-- Read the first set value among the given environment variable names.
local function env_first(...)
  for _, name in ipairs({ ... }) do
    local v = os.getenv(name)
    if v and v ~= "" then
      return v
    end
  end
  return nil
end

--- Whether `host` is excluded from proxying by the NO_PROXY / no_proxy env var.
---@param host string
---@return boolean
function M.host_in_no_proxy(host)
  local no_proxy = env_first("NO_PROXY", "no_proxy")
  if not no_proxy or host == "" then
    return false
  end
  for raw in no_proxy:gmatch("[^,]+") do
    local entry = raw:gsub("%s+", ""):gsub("^%*", ""):gsub("^%.", "") -- strip wildcard/leading dot
    if entry ~= "" and (host == entry or host:sub(-(#entry + 1)) == "." .. entry) then
      return true
    end
  end
  return false
end

--- Resolve the HTTP proxy to use for `host`.
--- Priority: explicit `git config http.gitlab.proxy`, then the standard
--- HTTPS_PROXY / HTTP_PROXY env vars (unless the host is in NO_PROXY).
--- gitlab.nvim's Go server uses a custom transport and does NOT honor the
--- env proxy on its own, so we must pass it explicitly.
---@param host string
---@return string
function M.proxy_for_host(host)
  local configured = vim.fn.system("git config --get http.gitlab.proxy 2>/dev/null"):gsub("%s+", "")
  if configured ~= "" then
    return configured
  end
  if host and host ~= "" and M.host_in_no_proxy(host) then
    return ""
  end
  return env_first("HTTPS_PROXY", "https_proxy", "HTTP_PROXY", "http_proxy") or ""
end

--- Read the GitLab token that `glab` uses for `host`, if glab is installed and
--- configured for it. This keeps a single source of truth so gitlab.nvim and
--- glab never drift out of sync (e.g. one having an expired token).
---@param host string
---@return string|nil
function M.glab_token_for_host(host)
  if not host or host == "" or vim.fn.executable("glab") == 0 then
    return nil
  end
  local token = vim.fn.system({ "glab", "config", "get", "token", "--host", host })
  if vim.v.shell_error ~= 0 then
    return nil
  end
  token = token:gsub("%s+", "")
  if token == "" then
    return nil
  end
  return token
end

return M
