-- set leader key to space (must be before lazy setup)
vim.g.mapleader = " "

require("config.options")
require("config.lazy")
require("config.keymaps")

-- Setup keymap checking utilities (run :CheckKeymaps to find conflicts)
require("utils.keymap_check").setup()
