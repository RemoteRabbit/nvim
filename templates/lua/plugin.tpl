;; lua
-- {{_file_name_}} - {{_input_:plugin_description_}}
-- Author: {{_author_}}
-- Date: {{_date_}}

local M = {}

-- Default configuration
M.config = {
  {{_input_:config_key_}} = {{_input_:config_value_}},
  debug = false,
}

-- Plugin state
local state = {
  initialized = false,
}

-- Internal functions
local function log(message, level)
  if M.config.debug then
    level = level or vim.log.levels.INFO
    vim.notify("[{{_input_:plugin_name_}}] " .. message, level)
  end
end

local function validate_config(opts)
  opts = opts or {}

  -- Validate required configuration
  if not opts.{{_input_:required_config_}} then
    error("{{_input_:required_config_}} is required")
  end

  return true
end

-- Public API functions
function M.{{_input_:main_function_}}()
  if not state.initialized then
    log("Plugin not initialized", vim.log.levels.WARN)
    return
  end

  {{_cursor_}}
end

function M.setup(opts)
  opts = opts or {}

  -- Validate configuration
  validate_config(opts)

  -- Merge user config with defaults
  M.config = vim.tbl_deep_extend("force", M.config, opts)

  log("Setting up {{_input_:plugin_name_}} plugin")

  -- Create autocommands
  local augroup = vim.api.nvim_create_augroup("{{_input_:plugin_name_}}", { clear = true })

  vim.api.nvim_create_autocmd("{{_input_:autocmd_event_}}", {
    group = augroup,
    callback = function()
      M.{{_input_:main_function_}}()
    end,
    desc = "{{_input_:autocmd_description_}}",
  })

  -- Create user commands
  vim.api.nvim_create_user_command("{{_input_:command_name_}}", function(args)
    M.{{_input_:main_function_}}()
  end, {
    desc = "{{_input_:command_description_}}",
    nargs = 0,
  })

  -- Set up keymaps if provided
  if M.config.keymaps then
    for mode, mappings in pairs(M.config.keymaps) do
      for lhs, rhs in pairs(mappings) do
        vim.keymap.set(mode, lhs, rhs, { desc = "{{_input_:plugin_name_}}: " .. lhs })
      end
    end
  end

  state.initialized = true
  log("{{_input_:plugin_name_}} plugin initialized successfully")
end

function M.toggle()
  if state.enabled then
    M.disable()
  else
    M.enable()
  end
end

function M.enable()
  state.enabled = true
  log("{{_input_:plugin_name_}} enabled")
end

function M.disable()
  state.enabled = false
  log("{{_input_:plugin_name_}} disabled")
end

-- Health check function
function M.health()
  local health = {}

  health.initialized = state.initialized
  health.config = M.config

  return health
end

return M
