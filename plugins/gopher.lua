--- gopher.nvim — Go codegen helpers that gopls doesn't cover:
---   :GoTagAdd/:GoTagRm   struct tags (gomodifytags)
---   :GoImpl              interface method stubs (impl)
---   :GoTestAdd/All/Exp   test skeletons (gotests)
---   :GoIfErr             `if err != nil` block (iferr)
---   :GoMod, :GoGet, :GoWork, :GoGenerate, :GoCmt, :GoNew
---
--- Its binaries are installed by mason (plugins/mason.lua); `:checkhealth gopher`
--- reports anything missing. Keymaps below are buffer-local to Go files.
return {
  src = "https://github.com/olexsmir/gopher.nvim",
  config = function()
    require("gopher").setup({})

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("gopher_keymaps", { clear = true }),
      pattern = "go",
      callback = function(ev)
        local map = function(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
        end
        map("<leader>Gj", "<cmd>GoTagAdd json<cr>", "Add json tags")
        map("<leader>Gy", "<cmd>GoTagAdd yaml<cr>", "Add yaml tags")
        map("<leader>GJ", "<cmd>GoTagRm json<cr>", "Remove json tags")
        map("<leader>GY", "<cmd>GoTagRm yaml<cr>", "Remove yaml tags")
        map("<leader>Gi", ":GoImpl ", "Implement interface")
        map("<leader>Ge", "<cmd>GoIfErr<cr>", "Insert if err != nil")
        map("<leader>Gt", "<cmd>GoTestAdd<cr>", "Generate test for func")
        map("<leader>GT", "<cmd>GoTestsAll<cr>", "Generate tests for file")
        map("<leader>Gc", "<cmd>GoCmt<cr>", "Generate doc comment")
        map("<leader>Gm", "<cmd>GoMod tidy<cr>", "go mod tidy")
        map("<leader>Gg", "<cmd>GoGenerate %<cr>", "go generate (file)")
      end,
    })
  end,
}
