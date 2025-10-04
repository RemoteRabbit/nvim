-- Multiple cursors
return {
  "mg979/vim-visual-multi",
  config = function()
    vim.g.VM_theme = "iceblue"
    vim.g.VM_highlight_matches = "hi! Search gui=underline"

    -- Keymaps (VM provides these by default, but documenting here)
    -- <C-n> - select word and next occurrence
    -- <C-Down>/<C-Up> - create cursor above/below
    -- n/N - navigate to next/prev occurrence
    -- [/] - navigate to next/prev cursor
    -- q - skip current and get next occurrence
    -- Q - remove current cursor/selection
  end,
}
