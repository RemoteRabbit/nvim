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

--- Plugins
--- Each file in the plugins/ dir returns a spec table:
---   return {
---     src = "https://github.com/owner/repo",  -- required
---     version = "v1.2.3" or "main",           -- optional (tag/branch/commit)
---     config = function() ... end,            -- optional, runs after install/load
---   }
local plugins_dir = vim.fn.stdpath("config") .. "/plugins"
local specs = {}
local configs = {}

for name, type_ in vim.fs.dir(plugins_dir) do
  if type_ == "file" and name:match("%.lua$") then
    local ok, plugin = pcall(dofile, plugins_dir .. "/" .. name)
    if not ok then
      vim.notify(
        ("Plugin spec '%s' failed to load (error while executing the file):\n%s"):format(name, tostring(plugin)),
        vim.log.levels.ERROR
      )
    elseif type(plugin) ~= "table" then
      vim.notify(
        ("Plugin spec '%s' did not return a table (got %s). Did you forget `return { ... }`?"):format(
          name,
          type(plugin)
        ),
        vim.log.levels.ERROR
      )
    elseif not plugin.src then
      vim.notify(("Plugin spec '%s' is missing the required `src` field."):format(name), vim.log.levels.ERROR)
    else
      table.insert(specs, { src = plugin.src, version = plugin.version })
      if type(plugin.config) == "function" then
        table.insert(configs, { name = name, src = plugin.src, fn = plugin.config })
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
  end
end

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
