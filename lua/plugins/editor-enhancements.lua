-- Editor enhancements: multiple cursors, text objects, surround, folding, snippets
return {
  {
    -- Multiple cursors
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
  },
  {
    -- Enhanced text objects
    "wellle/targets.vim",
    -- Provides enhanced text objects like:
    -- cin) - change inside next parentheses
    -- da, - delete around comma
    -- ci2) - change inside 2nd parentheses
  },
  {
    -- Additional text objects
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["ab"] = "@block.outer",
              ["ib"] = "@block.inner",
              ["al"] = "@loop.outer",
              ["il"] = "@loop.inner",
              ["ai"] = "@conditional.outer",
              ["ii"] = "@conditional.inner",
            },
            selection_modes = {
              ["@parameter.outer"] = "v",
              ["@function.outer"] = "V",
              ["@class.outer"] = "<c-v>",
            },
            include_surrounding_whitespace = true,
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
              ["]a"] = "@parameter.inner",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
              ["]A"] = "@parameter.inner",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
              ["[a"] = "@parameter.inner",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
              ["[A"] = "@parameter.inner",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>sn"] = "@parameter.inner",
              ["<leader>sm"] = "@function.outer",
            },
            swap_previous = {
              ["<leader>sp"] = "@parameter.inner",
              ["<leader>sM"] = "@function.outer",
            },
          },
        },
      })
    end,
  },
  {
    -- Smart surround
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          insert = "<C-g>s",
          insert_line = "<C-g>S",
          normal = "ys",
          normal_cur = "yss",
          normal_line = "yS",
          normal_cur_line = "ySS",
          visual = "S",
          visual_line = "gS",
          delete = "ds",
          change = "cs",
          change_line = "cS",
        },
        surrounds = {
          ["("] = {
            add = { "(", ")" },
            find = function()
              return M.get_selection({ motion = "a(" })
            end,
            delete = "^(.)().-(.)()$",
          },
          [")"] = {
            add = { "( ", " )" },
            find = function()
              return M.get_selection({ motion = "a)" })
            end,
            delete = "^(. ?)().-(.? ?)()$",
          },
          ["{"] = {
            add = { "{", "}" },
            find = function()
              return M.get_selection({ motion = "a{" })
            end,
            delete = "^(.)().-(.)()$",
          },
          ["}"] = {
            add = { "{ ", " }" },
            find = function()
              return M.get_selection({ motion = "a}" })
            end,
            delete = "^(. ?)().-(.? ?)()$",
          },
          ["<"] = {
            add = { "<", ">" },
            find = function()
              return M.get_selection({ motion = "a<" })
            end,
            delete = "^(.)().-(.)()$",
          },
          [">"] = {
            add = { "< ", " >" },
            find = function()
              return M.get_selection({ motion = "a>" })
            end,
            delete = "^(. ?)().-(.? ?)()$",
          },
          -- Custom surrounds
          ["f"] = {
            add = function()
              local config = require("nvim-surround.config")
              local result = config.get_input("Enter the function name: ")
              if result then
                return { { result .. "(" }, { ")" } }
              end
            end,
            find = function()
              return config.get_selection({ motion = "a(" })
            end,
            delete = "^(.-)%b()()()$",
          },
        },
        aliases = {
          ["a"] = ">",
          ["b"] = ")",
          ["B"] = "}",
          ["r"] = "]",
          ["q"] = { '"', "'", "`" },
          ["s"] = { "}", "]", ")", ">", '"', "'", "`" },
        },
        highlight = {
          duration = 0,
        },
        move_cursor = "begin",
        indent_lines = function(start, stop)
          local b = vim.bo
          return start < stop and (b.autoindent or b.smartindent or b.cindent)
        end,
      })
    end,
  },
  {
    -- Advanced folding with treesitter
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end,
        open_fold_hl_timeout = 150,
        close_fold_kinds_for_ft = {
          default = { "imports", "comment" },
          json = { "array" },
          c = { "comment", "region" },
        },
        preview = {
          win_config = {
            border = { "", "─", "", "", "", "─", "", "" },
            winhighlight = "Normal:Folded",
            winblend = 0,
          },
          mappings = {
            scrollU = "<C-u>",
            scrollD = "<C-d>",
            jumpTop = "[",
            jumpBot = "]",
          },
        },
      })

      -- Keymaps
      vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
      vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds, { desc = "Open folds except kinds" })
      vim.keymap.set("n", "zm", require("ufo").closeFoldsWith, { desc = "Close folds with" })
      vim.keymap.set("n", "K", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end, { desc = "Peek fold or hover" })
    end,
  },
  {
    -- Enhanced snippets
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local luasnip = require("luasnip")

      luasnip.setup({
        history = true,
        delete_check_events = "TextChanged",
        region_check_events = "CursorMoved",
        enable_autosnippets = true,
        store_selection_keys = "<Tab>",
        ft_func = function()
          return vim.split(vim.bo.filetype, ".", { plain = true })
        end,
      })

      -- Load VSCode snippets
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load({ paths = "~/.config/nvim/snippets" })

      -- Load custom Lua snippets
      require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets" })

      -- Custom snippets
      local s = luasnip.snippet
      local t = luasnip.text_node
      local i = luasnip.insert_node
      local extras = require("luasnip.extras")
      local rep = extras.rep
      local fmt = require("luasnip.extras.fmt").fmt

      luasnip.add_snippets("python", {
        s(
          "def",
          fmt(
            [[
        def {}({}):
            """{}"""
            {}
        ]],
            { i(1, "function_name"), i(2), i(3, "Description"), i(0) }
          )
        ),

        s(
          "class",
          fmt(
            [[
        class {}({}):
            """{}"""

            def __init__(self{}):
                {}
        ]],
            { i(1, "ClassName"), i(2, "object"), i(3, "Description"), i(4), i(0) }
          )
        ),

        s(
          "ifmain",
          t({
            'if __name__ == "__main__":',
            "    main()",
          })
        ),
      })

      luasnip.add_snippets("go", {
        s(
          "func",
          fmt(
            [[
        func {}({}) {} {{
            {}
        }}
        ]],
            { i(1, "functionName"), i(2), i(3, "returnType"), i(0) }
          )
        ),

        s(
          "struct",
          fmt(
            [[
        type {} struct {{
            {}
        }}
        ]],
            { i(1, "StructName"), i(0) }
          )
        ),

        s(
          "iferr",
          t({
            "if err != nil {",
            "\treturn err",
            "}",
          })
        ),
      })

      luasnip.add_snippets("terraform", {
        s(
          "resource",
          fmt(
            [[
        resource "{}" "{}" {{
            {}
        }}
        ]],
            { i(1, "resource_type"), i(2, "name"), i(0) }
          )
        ),

        s(
          "variable",
          fmt(
            [[
        variable "{}" {{
            description = "{}"
            type        = {}
            default     = {}
        }}
        ]],
            { i(1, "var_name"), i(2, "description"), i(3, "string"), i(0) }
          )
        ),

        s(
          "output",
          fmt(
            [[
        output "{}" {{
            description = "{}"
            value       = {}
        }}
        ]],
            { i(1, "output_name"), i(2, "description"), i(0) }
          )
        ),
      })

      -- Keymaps
      vim.keymap.set({ "i" }, "<C-K>", function()
        luasnip.expand()
      end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-L>", function()
        luasnip.jump(1)
      end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-J>", function()
        luasnip.jump(-1)
      end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-E>", function()
        if luasnip.choice_active() then
          luasnip.change_choice(1)
        end
      end, { silent = true })
    end,
  },
  {
    -- Smart auto-pairs
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      local Rule = require("nvim-autopairs.rule")
      local ts_conds = require("nvim-autopairs.ts-conds")

      autopairs.setup({
        check_ts = true,
        ts_config = {
          lua = { "string", "source" },
          javascript = { "string", "template_string" },
          java = false,
        },
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        disable_in_macro = true,
        disable_in_visualblock = false,
        disable_in_replace_mode = true,
        ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
        enable_moveright = true,
        enable_afterquote = true,
        enable_check_bracket_line = true,
        enable_bracket_in_quote = true,
        enable_abbr = false,
        break_undo = true,
        check_comma = true,
        map_cr = true,
        map_bs = true,
        map_c_h = false,
        map_c_w = false,
      })

      -- Custom rules
      autopairs.add_rules({
        Rule("$", "$", { "tex", "latex" }):with_pair(ts_conds.is_not_ts_node({ "string", "comment" })),
        Rule("/**", "**/", "javascript"):with_pair(ts_conds.is_ts_node({ "comment" })),
      })

      -- Integration with cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
}
