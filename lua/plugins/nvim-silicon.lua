-- Code screenshots
return {
  "michaelrommel/nvim-silicon",
  lazy = true,
  cmd = "Silicon",
  config = function()
    require("silicon").setup({
      font = "JetBrainsMono Nerd Font=34;Noto Color Emoji=34",
      theme = "Dracula",
      background = "#AAAAFF",
      shadow_color = "#555555",
      line_pad = 2,
      pad_horiz = 80,
      pad_vert = 100,
      shadow_blur_radius = 0,
      shadow_offset_x = 0,
      shadow_offset_y = 0,
      line_number = false, -- Use false to avoid --no-line-number flag
      round_corner = false, -- Use false to avoid --no-round-corner flag
      window_controls = false, -- Use false to avoid --no-window-controls flag
      output = function()
        return "~/Pictures/silicon-" .. os.date("%Y-%m-%d-%H%M%S") .. ".png"
      end,
      debug = false,
    })

    -- Keymaps
    vim.keymap.set("v", "<leader>sc", ":Silicon<cr>", { desc = "Screenshot code" })
    vim.keymap.set("n", "<leader>sc", ":Silicon<cr>", { desc = "Screenshot code" })
  end,
}
