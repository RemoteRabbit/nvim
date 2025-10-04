-- Elixir tools
return {
  {
    -- Elixir tools
    "elixir-tools/elixir-tools.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local elixir = require("elixir")
      local elixirls = require("elixir.elixirls")

      elixir.setup({
        nextls = {
          enable = true,
          init_options = {
            mix_env = "dev",
            mix_target = "host",
            experimental = {
              completions = {
                enable = true,
              },
            },
          },
        },
        credo = {
          enable = true,
        },
        elixirls = {
          enable = true,
          settings = elixirls.settings({
            dialyzerEnabled = false,
            enableTestLenses = false,
          }),
        },
        -- Disable lexical to avoid conflicts
        lexical = {
          enable = false,
        },
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}
