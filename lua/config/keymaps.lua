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

-- Box-drawing & arrow picker (insert at cursor)
local box_chars = {
  { text = "─ horizontal",        char = "─" },
  { text = "│ vertical",          char = "│" },
  { text = "┌ corner top-left",   char = "┌" },
  { text = "┐ corner top-right",  char = "┐" },
  { text = "└ corner bot-left",   char = "└" },
  { text = "┘ corner bot-right",  char = "┘" },
  { text = "├ tee right",         char = "├" },
  { text = "┤ tee left",          char = "┤" },
  { text = "┬ tee down",          char = "┬" },
  { text = "┴ tee up",            char = "┴" },
  { text = "┼ cross",             char = "┼" },
  { text = "╭ round top-left",    char = "╭" },
  { text = "╮ round top-right",   char = "╮" },
  { text = "╰ round bot-left",    char = "╰" },
  { text = "╯ round bot-right",   char = "╯" },
  { text = "═ double horizontal", char = "═" },
  { text = "║ double vertical",   char = "║" },
  { text = "▶ arrow right",       char = "▶" },
  { text = "◀ arrow left",        char = "◀" },
  { text = "▲ arrow up",          char = "▲" },
  { text = "▼ arrow down",        char = "▼" },
  { text = "→ thin arrow right",  char = "→" },
  { text = "← thin arrow left",   char = "←" },
  { text = "↑ thin arrow up",     char = "↑" },
  { text = "↓ thin arrow down",   char = "↓" },
}

keymap.set({ "n", "i" }, "<leader>ub", function()
  local mode = vim.api.nvim_get_mode().mode
  Snacks.picker.pick({
    source = "box_chars",
    items = box_chars,
    format = "text",
    layout = { preset = "select" },
    confirm = function(picker, item)
      picker:close()
      if not item then return end
      vim.schedule(function()
        if mode:sub(1, 1) == "i" then
          vim.api.nvim_put({ item.char }, "c", false, true)
          vim.cmd("startinsert")
        else
          vim.api.nvim_put({ item.char }, "c", true, true)
        end
      end)
    end,
  })
end, { desc = "Pick box-drawing char" })

-- Wrap selected lines in a box
local function box_wrap(opts)
  local s_line = opts.line1
  local e_line = opts.line2
  local lines = vim.api.nvim_buf_get_lines(0, s_line - 1, e_line, false)

  local max = 0
  for i, l in ipairs(lines) do
    lines[i] = l:gsub("%s+$", "")
    local w = vim.fn.strdisplaywidth(lines[i])
    if w > max then max = w end
  end

  local style = opts.args ~= "" and opts.args or "round"
  local styles = {
    round  = { tl = "╭", tr = "╮", bl = "╰", br = "╯", h = "─", v = "│" },
    sharp  = { tl = "┌", tr = "┐", bl = "└", br = "┘", h = "─", v = "│" },
    double = { tl = "╔", tr = "╗", bl = "╚", br = "╝", h = "═", v = "║" },
  }
  local s = styles[style] or styles.round

  local out = { s.tl .. s.h:rep(max + 2) .. s.tr }
  for _, l in ipairs(lines) do
    local pad = max - vim.fn.strdisplaywidth(l)
    table.insert(out, s.v .. " " .. l .. string.rep(" ", pad) .. " " .. s.v)
  end
  table.insert(out, s.bl .. s.h:rep(max + 2) .. s.br)

  vim.api.nvim_buf_set_lines(0, s_line - 1, e_line, false, out)
end

vim.api.nvim_create_user_command("Box", box_wrap, {
  range = true,
  nargs = "?",
  complete = function() return { "round", "sharp", "double" } end,
  desc = "Wrap selected lines in a box (round|sharp|double)",
})

keymap.set("v", "<leader>ub", ":Box<CR>", { desc = "Box-wrap selection" })

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
