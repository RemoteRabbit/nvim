-- Luacheck configuration for Neovim Lua files
stds.nvim = {
  globals = {
    "vim",
    "describe", "it", "before_each", "after_each", -- For tests
  },
  read_globals = {
    "jit", "os", "debug", "package",
  }
}

std = "lua51+nvim"
cache = true
codes = true

-- Ignore some common warnings in Neovim configs
ignore = {
  "212/_.*", -- unused argument, for vars with "_" prefix
  "214",     -- used variable with unused hint ("_" prefix)
  "121",     -- setting read-only global variable 'vim'
  "122",     -- setting read-only field of global variable 'vim'
  "211",     -- unused variable (common in plugin setup)
  "212",     -- unused argument (common in callbacks)
  "213",     -- unused loop variable
  "113",     -- accessing undefined variable (plugin globals)
  "111",     -- setting non-standard global variable (plugin globals)
  "431",     -- shadowing upvalue (common in nested functions)
  "311",     -- value assigned to variable is unused
  "631",     -- line is too long (already handled by stylua)
}

-- Files and patterns to exclude
exclude_files = {
  ".git/",
  "lazy-lock.json",
}

-- Only check Lua files
include_files = {
  "**/*.lua",
  ".luacheckrc",
}

-- Max line length (matches stylua config)
max_line_length = 120
