return {
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
}
