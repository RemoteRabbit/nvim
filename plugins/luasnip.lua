--- LuaSnip — the snippet engine that blink.cmp drives (see plugins/blink.lua,
--- `snippets.preset = "luasnip"`).
---
--- Two sources of snippets are loaded:
---   1. friendly-snippets — community VSCode-style snippets (a broad base).
---   2. Your own native Lua snippets in <config>/snippets/<filetype>.lua, which
---      are the powerful/dynamic ones (functions, choices, transforms, etc.).
---
--- Snippet jumping (Tab / S-Tab) is configured in plugins/blink.lua.
return {
  {
    src = "https://github.com/rafamadriz/friendly-snippets",
  },
  {
    src = "https://github.com/L3MON4D3/LuaSnip",
    version = vim.version.range("2.*"),
    config = function()
      local ls = require("luasnip")

      ls.setup({
        -- Keep the last snippet around so you can jump back into it.
        history = true,
        -- Re-read tabstops as you type so dynamic nodes update live.
        update_events = "TextChanged,TextChangedI",
        enable_autosnippets = true,
      })

      -- Community VSCode-style snippets (friendly-snippets) + any VSCode-style
      -- snippets you drop in <config>/snippets with a package.json.
      require("luasnip.loaders.from_vscode").lazy_load()

      -- Your native Lua snippets: <config>/snippets/<filetype>.lua
      require("luasnip.loaders.from_lua").lazy_load({
        paths = { vim.fn.stdpath("config") .. "/snippets" },
      })

      -- Edit the Lua snippets file for the current filetype.
      vim.keymap.set("n", "<leader>se", function()
        require("luasnip.loaders").edit_snippet_files()
      end, { desc = "Edit snippets" })

      if not pcall(require, "luasnip-jsregexp") and not pcall(require, "jsregexp") then
        local info = vim.iter(vim.pack.get()):find(function(p)
          return p.spec and p.spec.name == "LuaSnip"
        end)
        if info and info.path and vim.fn.executable("make") == 1 then
          vim.system(
            { "make", "install_jsregexp" },
            { cwd = info.path },
            vim.schedule_wrap(function(out)
              if out.code ~= 0 then
                vim.notify(
                  "LuaSnip: jsregexp build failed (snippet transforms disabled):\n" .. (out.stderr or ""),
                  vim.log.levels.WARN
                )
              end
            end)
          )
        end
      end
    end,
  },
}
