local keymap = vim.keymap -- for conciseness

-- General Keymaps -------------------
keymap.set("n", "<leader>L", ":Lazy<CR>", { desc = "Lazy" })
keymap.set("n", "<leader>pm", ":Mason<CR>", { desc = "Mason" })

keymap.set("n", "<leader>cw", ":%s/<C-r><C-w>//g<Left><Left>", { desc = "Change word" })

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>=", "<C-x>", { desc = "Decrement number" })

-- windows
keymap.set("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
keymap.set("n", "<leader>w-", "<C-W>s", { desc = "Split window below", remap = true })
keymap.set("n", "<leader>w|", "<C-W>v", { desc = "Split window right", remap = true })
keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })

-- tabs
keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
keymap.set("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
keymap.set("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Alternative simple tab navigation
keymap.set("n", "gt", "<cmd>tabnext<cr>", { desc = "Next Tab" })
keymap.set("n", "gT", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Sesh - tmux session picker
keymap.set("n", "<leader>fs", function()
  vim.fn.system([[
    tmux display-popup -E -w 55% -h 60% 'sesh connect "$(
      sesh list | fzf \
        --no-sort --border-label " sesh " --prompt "⚡ " \
        --header "^a all ^t tmux ^x zoxide ^g config ^d kill ^f find" \
        --bind "tab:down,btab:up" \
        --bind "ctrl-a:change-prompt(⚡ )+reload(sesh list)" \
        --bind "ctrl-t:change-prompt(🪟 )+reload(sesh list -t)" \
        --bind "ctrl-g:change-prompt(⚙️ )+reload(sesh list -c)" \
        --bind "ctrl-x:change-prompt(📁 )+reload(sesh list -z)" \
        --bind "ctrl-f:change-prompt(🔎 )+reload(fd -H -d 2 -t d -E .Trash . ~)" \
        --bind "ctrl-d:execute(tmux kill-session -t {})+change-prompt(⚡ )+reload(sesh list)"
    )"'
  ]])
end, { desc = "Sesh tmux sessions" })
