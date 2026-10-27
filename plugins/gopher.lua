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
---   go commands   m go mod tidy · g go get (prompt) · G go generate (file)
---                 b go build ./... · v go vet ./... (errors -> quickfix)
---                 x go run . (terminal split, package of the current file)
return {
  src = "https://github.com/olexsmir/gopher.nvim",
  version = vim.version.range("0.*"),
  config = function()
    require("gopher").setup({})

    --- Mapping that runs `[range]cmd [input]`, keeping a visual range.
    --- `prompt` asks for the input first. `save` writes the buffer before
    --- running: gomodifytags (GoTag*) reads the file from disk, so unsaved
    --- edits make it fail ("struct name does not exist") or splice its
    --- output over the wrong lines.
    ---@param cmd string Ex command, optionally with fixed arguments
    ---@param opts? { prompt?: string, save?: boolean }
    ---@return function
    local function go_cmd(cmd, opts)
      opts = opts or {}
      return function()
        local range = ""
        if vim.fn.mode():match("[vV\22]") then
          local s, e = vim.fn.line("v"), vim.fn.line(".")
          range = math.min(s, e) .. "," .. math.max(s, e)
          vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
        end
        local function run(input)
          if opts.save then
            vim.cmd("silent update")
            -- Format-on-save may have changed the buffer; refresh the tree
            -- gopher uses to find the struct under the cursor.
            vim.treesitter.get_parser():parse()
          end
          vim.cmd(range .. cmd .. (input and " " .. input or ""))
        end
        if not opts.prompt then
          return run()
        end
        vim.ui.input({ prompt = opts.prompt }, function(input)
          if input ~= nil then
            run(input)
          end
        end)
      end
    end

    --- Run `go <args>` from the buffer's module root and load the errors into
    --- the quickfix list (opened when there are any).
    ---@param buf integer
    ---@param args string[]
    local function go_quickfix(buf, args)
      local root = vim.fs.root(buf, "go.mod") or vim.fs.dirname(vim.api.nvim_buf_get_name(buf))
      local title = "go " .. table.concat(args, " ")
      vim.notify(title .. " …")
      vim.system(vim.list_extend({ "go" }, args), { cwd = root, text = true }, function(out)
        vim.schedule(function()
          -- go prints paths relative to `root` (vet type errors prefixed with
          -- "vet: "); make them absolute so quickfix resolves them from any cwd.
          local lines = vim.tbl_map(function(line)
            local file, rest = line:gsub("^vet: ", ""):match("^([^%s:]+%.go)(:.*)$")
            if not file then
              return line
            end
            if not vim.startswith(file, "/") then
              file = vim.fs.normalize(vim.fs.joinpath(root, file))
            end
            return file .. rest
          end, vim.split(out.stdout .. out.stderr, "\n", { trimempty = true }))
          -- Same errorformat as Neovim's `:compiler go`.
          local efm = [[%-G# %.%#,%A%f:%l:%c: %m,%A%f:%l: %m,%C%*\s%m,%-G%.%#]]
          vim.fn.setqflist({}, " ", { title = title, lines = lines, efm = efm })
          local items = vim.tbl_filter(function(item)
            return item.valid == 1
          end, vim.fn.getqflist())
          if #items > 0 then
            vim.cmd("botright copen")
          elseif out.code ~= 0 then
            vim.notify(title .. " failed:\n" .. table.concat(lines, "\n"), vim.log.levels.ERROR)
          else
            vim.cmd("cclose")
            vim.notify(title .. ": ok")
          end
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

        -- Struct tags (save first; j/y/a/r pass a visual range along).
        map(nx, "<leader>Gj", go_cmd("GoTagAdd json", { save = true }), "Add json tags")
        map(nx, "<leader>Gy", go_cmd("GoTagAdd yaml", { save = true }), "Add yaml tags")
        map(
          nx,
          "<leader>Ga",
          go_cmd("GoTagAdd", { prompt = "Add tags (e.g. json=omitempty db): ", save = true }),
          "Add tags…"
        )
        map(
          nx,
          "<leader>Gr",
          go_cmd("GoTagRm", { prompt = "Remove tags (empty = json): ", save = true }),
          "Remove tags…"
        )
        map("n", "<leader>GR", go_cmd("GoTagClear", { save = true }), "Clear all tags")

        -- Code generation
        map("n", "<leader>Gi", go_cmd("GoImpl", { prompt = "Implement (e.g. io.Reader): " }), "Implement interface…")
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

        -- go commands
        map("n", "<leader>Gm", "<cmd>GoMod tidy<cr>", "go mod tidy")
        map("n", "<leader>Gg", go_cmd("GoGet", { prompt = "go get: " }), "go get…")
        map("n", "<leader>GG", "<cmd>GoGenerate %<cr>", "go generate (file)")
        map("n", "<leader>Gb", function()
          go_quickfix(ev.buf, { "build", "./..." })
        end, "go build ./... (quickfix)")
        map("n", "<leader>Gv", function()
          go_quickfix(ev.buf, { "vet", "./..." })
        end, "go vet ./... (quickfix)")
        map("n", "<leader>Gx", function()
          local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(ev.buf))
          vim.cmd("botright 15new")
          vim.fn.jobstart({ "go", "run", "." }, { term = true, cwd = dir })
          vim.cmd.startinsert()
        end, "go run . (terminal)")
      end,
    })
  end,
}
