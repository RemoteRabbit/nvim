--- gopher.nvim — Go code generation on top of the Go tool binaries
--- (gomodifytags, impl, gotests, iferr, json2go). It is NOT an LSP plugin:
--- definitions/hover/rename/diagnostics come from gopls (plugins/lspconfig.lua),
--- formatting from conform, debugging from plugins/dap.lua.
---
--- Missing binaries: run `:GoInstallDeps`, then `:checkhealth gopher`.
---
--- All keymaps are buffer-local to Go files, under <leader>G:
---   struct tags   j json · y yaml · a add (prompt) · r remove (prompt) · R clear
---                 (j/y/a/r also work on a visual selection of fields)
---   generate      i impl interface · e if err · n constructor · c doc comment
---                 s JSON -> struct
---   tests         t test for func · T tests for file · E tests for exported
---                 o switch between foo.go / foo_test.go
---   docs          d full `go doc` for symbol under cursor in a split (q closes)
---   go commands   m go mod tidy · g go get (prompt) · G go generate (file)
return {
  src = "https://github.com/olexsmir/gopher.nvim",
  version = vim.version.range("0.*"),
  config = function()
    require("gopher").setup({})

    --- Prompt for arguments, then run `cmd <input>`; keeps a visual range.
    ---@param cmd string Ex command name
    ---@param prompt string
    ---@return function
    local function prompt_cmd(cmd, prompt)
      return function()
        local range = ""
        if vim.fn.mode():match("[vV\22]") then
          local s, e = vim.fn.line("v"), vim.fn.line(".")
          range = math.min(s, e) .. "," .. math.max(s, e)
          vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
        end
        vim.ui.input({ prompt = prompt }, function(input)
          if input ~= nil then
            vim.cmd(range .. cmd .. " " .. input)
          end
        end)
      end
    end

    --- Full `go doc -all` for the symbol under the cursor, in a reusable split.
    --- Unlike K (hover), this includes every method/field doc of a type, or the
    --- whole package when the cursor is on a package name. gopls resolves the
    --- symbol (aliases, dependencies, local packages) via the pkg.go.dev link
    --- it puts in hover text; `go doc` then runs from the file's directory so
    --- module dependencies resolve.
    ---@param buf integer
    local function godoc_split(buf)
      local params = vim.lsp.util.make_position_params(0, "utf-16")
      vim.lsp.buf_request_all(buf, "textDocument/hover", params, function(results)
        local target
        for _, res in pairs(results) do
          local value = vim.tbl_get(res, "result", "contents", "value") or ""
          local path, sym = value:match("https://pkg%.go%.dev/([^#%)]+)#?([%w_%.]*)")
          if path then
            -- Drop a module version (github.com/x/y@v1.2.3/sub -> github.com/x/y/sub).
            target = { path:gsub("@[^/]+", ""), sym ~= "" and sym or nil }
            break
          end
        end
        if not target then
          vim.notify("No Go documentation for symbol under cursor", vim.log.levels.WARN)
          return
        end

        local cmd = vim.list_extend({ "go", "doc", "-all" }, target)
        local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(buf))
        vim.system(cmd, { cwd = dir, text = true }, function(out)
          vim.schedule(function()
            if out.code ~= 0 then
              vim.notify(vim.trim(out.stderr), vim.log.levels.WARN)
              return
            end
            -- Reuse the godoc window in this tab, otherwise open a vertical split.
            local win = vim.iter(vim.api.nvim_tabpage_list_wins(0)):find(function(w)
              return vim.bo[vim.api.nvim_win_get_buf(w)].filetype == "godoc"
            end)
            local doc
            if win then
              doc = vim.api.nvim_win_get_buf(win)
              vim.api.nvim_set_current_win(win)
            else
              doc = vim.api.nvim_create_buf(false, true)
              vim.bo[doc].bufhidden = "wipe"
              -- Own filetype so gopls/conform don't attach; Go syntax colors.
              vim.bo[doc].filetype = "godoc"
              pcall(vim.treesitter.start, doc, "go")
              vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = doc, desc = "Close godoc" })
              vim.cmd("vertical sbuffer " .. doc)
            end
            pcall(vim.api.nvim_buf_set_name, doc, "godoc://" .. table.concat(target, " "))
            vim.bo[doc].modifiable = true
            vim.api.nvim_buf_set_lines(doc, 0, -1, false, vim.split(vim.trim(out.stdout), "\n"))
            vim.bo[doc].modifiable = false
            vim.api.nvim_win_set_cursor(0, { 1, 0 })
          end)
        end)
      end)
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("gopher_keymaps", { clear = true }),
      pattern = "go",
      callback = function(ev)
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
        end
        local nx = { "n", "x" }

        -- Struct tags (`:` instead of <cmd> so a visual range is passed along).
        map(nx, "<leader>Gj", ":GoTagAdd json<cr>", "Add json tags")
        map(nx, "<leader>Gy", ":GoTagAdd yaml<cr>", "Add yaml tags")
        map(nx, "<leader>Ga", prompt_cmd("GoTagAdd", "Add tags (e.g. json=omitempty db): "), "Add tags…")
        map(nx, "<leader>Gr", prompt_cmd("GoTagRm", "Remove tags (empty = json): "), "Remove tags…")
        map("n", "<leader>GR", "<cmd>GoTagClear<cr>", "Clear all tags")

        -- Code generation
        map("n", "<leader>Gi", prompt_cmd("GoImpl", "Implement (e.g. io.Reader): "), "Implement interface…")
        map("n", "<leader>Ge", "<cmd>GoIfErr<cr>", "Insert if err != nil")
        map("n", "<leader>Gn", "<cmd>GoNew<cr>", "Generate constructor")
        map("n", "<leader>Gc", "<cmd>GoCmt<cr>", "Generate doc comment")
        map("n", "<leader>Gs", "<cmd>GoJson<cr>", "JSON to struct")

        -- Tests
        map("n", "<leader>Gt", "<cmd>GoTestAdd<cr>", "Generate test for function")
        map("n", "<leader>GT", "<cmd>GoTestsAll<cr>", "Generate tests for file")
        map("n", "<leader>GE", "<cmd>GoTestsExp<cr>", "Generate tests for exported")
        map("n", "<leader>Go", function()
          local file = vim.api.nvim_buf_get_name(ev.buf)
          local alt = file:match("_test%.go$") and file:gsub("_test%.go$", ".go") or file:gsub("%.go$", "_test.go")
          vim.cmd.edit(vim.fn.fnameescape(alt))
        end, "Alternate test/impl file")

        -- Docs
        map("n", "<leader>Gd", function()
          godoc_split(ev.buf)
        end, "Go doc in split (full)")

        -- go commands
        map("n", "<leader>Gm", "<cmd>GoMod tidy<cr>", "go mod tidy")
        map("n", "<leader>Gg", prompt_cmd("GoGet", "go get: "), "go get…")
        map("n", "<leader>GG", "<cmd>GoGenerate %<cr>", "go generate (file)")
      end,
    })
  end,
}
