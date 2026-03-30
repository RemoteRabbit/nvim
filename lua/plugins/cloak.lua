return {
  "laytan/cloak.nvim",
  event = "BufReadPre",
  config = function()
    require("cloak").setup({
      enabled = true,
      cloak_character = "*",
      highlight_group = "Comment",
      patterns = {
        {
          file_pattern = {
            ".env*",
            ".env",
            ".edgerc",
            ".credentials",
          },
          cloak_pattern = "=.+",
        },
      },
    })
  end,
}
