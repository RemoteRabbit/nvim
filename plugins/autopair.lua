return {
  src = "https://github.com/windwp/nvim-autopairs",
  version = "0.10.0",
  config = function()
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    local cond = require("nvim-autopairs.conds")
    local utils = require("nvim-autopairs.utils")
    npairs.setup()

    -- Go struct tags (`json:"id"`): the default `"` rule never pairs inside a
    -- backtick string (it counts ` as a quote) or right before a closing `.
    -- Go gets its own rule that only refuses to pair inside a "..." string.
    npairs.get_rules('"')[1].not_filetypes = { "vim", "go" }
    npairs.add_rule(Rule('"', '"', "go")
      :with_pair(function(opts)
        if utils.is_in_quotes(opts.text, opts.col - 1, '"') then
          return false
        end
      end)
      :with_pair(cond.not_after_regex("[%w%%'%[\"%.%$]"))
      :with_move(cond.move_right())
      :use_undo(true))
  end,
}
