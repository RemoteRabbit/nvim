--- Color and Theme
vim.opt.termguicolors = true
vim.cmd.colorscheme("catppuccin")

--- Global options
vim.g.netrw_banner = 0
vim.g.mapleader = " " -- space for leader
vim.g.maplocalleader = " " -- space for localleader
-- Disable unused language providers (avoids checkhealth noise + startup cost)
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

--- Load
require("autocmds")
require("keymaps")
require("options")
require("utils.keymapdoc").setup()

--- Plugins
--- Each file in the plugins/ dir returns either a single spec table, or a
--- list of spec tables (for plugins that must be installed/configured
--- together, e.g. mason + mason-lspconfig).
---
---   return {
---     src = "https://github.com/owner/repo",  -- required
---     version = "v1.2.3" or "main",           -- optional (tag/branch/commit)
---     config = function() ... end,            -- optional, runs after install/load
---     priority = 100,                         -- optional, higher runs first (default 0)
---   }
---
--- Configs run sorted by `priority` (desc), then file name (asc) for
--- deterministic ordering. Use `priority` for load-order dependencies.
local plugins_dir = vim.fn.stdpath("config") .. "/plugins"

---@type table Table holding compiled set of @configs
local specs = {}

---@type table Table holding individual plugin configurations.
local configs = {}

--- Validate a single spec and queue its add-spec/config.
---@param name string Spec file name (used in error messages)
---@param plugin table Spec table returned by a plugins/*.lua file
---@return nil
local function process_spec(name, plugin)
  if type(plugin) ~= "table" then
    vim.notify(
      ("Plugin spec '%s' did not return a table (got %s). Did you forget `return { ... }`?"):format(name, type(plugin)),
      vim.log.levels.ERROR
    )
    return
  elseif not plugin.src then
    vim.notify(("Plugin spec '%s' is missing the required `src` field."):format(name), vim.log.levels.ERROR)
    return
  end

  table.insert(specs, { src = plugin.src, version = plugin.version })
  if type(plugin.config) == "function" then
    table.insert(configs, {
      name = name,
      src = plugin.src,
      fn = plugin.config,
      priority = plugin.priority or 0,
    })
  elseif plugin.config ~= nil then
    vim.notify(
      ("Plugin spec '%s' has a `config` that is not a function (got %s); skipping it."):format(
        name,
        type(plugin.config)
      ),
      vim.log.levels.WARN
    )
  end
end

for name, type_ in vim.fs.dir(plugins_dir) do
  if type_ == "file" and name:match("%.lua$") then
    local ok, plugin = pcall(dofile, plugins_dir .. "/" .. name)
    if not ok then
      vim.notify(
        ("Plugin spec '%s' failed to load (error while executing the file):\n%s"):format(name, tostring(plugin)),
        vim.log.levels.ERROR
      )
    elseif type(plugin) == "table" and plugin.src == nil and plugin[1] ~= nil then
      -- A list of specs.
      for _, sub in ipairs(plugin) do
        process_spec(name, sub)
      end
    else
      -- A single spec.
      process_spec(name, plugin)
    end
  end
end

--- Deterministic order: higher priority first, then file name.
table.sort(configs, function(a, b)
  if a.priority ~= b.priority then
    return a.priority > b.priority
  end
  return a.name < b.name
end)

local ok_add, add_err = pcall(vim.pack.add, specs)
if not ok_add then
  vim.notify("vim.pack.add failed:\n" .. tostring(add_err), vim.log.levels.ERROR)
end

for _, config in ipairs(configs) do
  local ok, err = pcall(config.fn)
  if not ok then
    vim.notify(
      ("Plugin config error in '%s' (%s):\n%s"):format(config.name, config.src, tostring(err)),
      vim.log.levels.ERROR
    )
  end
end
