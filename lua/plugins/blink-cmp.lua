return {
  "saghen/blink.cmp",
  dependencies = { "allaman/emoji.nvim", "saghen/blink.compat", "rafamadriz/friendly-snippets" },
  optional = true,
  version = "*",
  opts = {
    keymap = {
      preset = "default",
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<C-y>"] = { "accept", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
    },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },

    sources = {
      default = { "emoji", "lsp", "path", "snippets", "buffer" },
      providers = {
        buffer = {
          min_keyword_length = 3,
        },
        emoji = {
          name = "emoji",
          module = "blink.compat.source",
          transform_items = function(ctx, items)
            local kind = require("blink.cmp.types").CompletionItemKind.Text
            for i = 1, #items do
              items[i].kind = kind
            end
            return items
          end,
        },
        lsp = {
          -- Enhanced LSP completion for Terraform
          transform_items = function(ctx, items)
            -- Show more details for Terraform module variables
            if vim.bo.filetype == "terraform" then
              for i = 1, #items do
                local item = items[i]
                if item.detail and item.detail:match("variable") then
                  item.label_description = item.detail
                end
              end
            end
            return items
          end,
        },
      },
    },

    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        update_delay_ms = 50,
        window = {
          border = "rounded",
        },
      },
      menu = {
        border = "rounded",
        auto_show = true,
        max_height = 10,
        scrolloff = 2,
        scrollbar = true,
        draw = {
          treesitter = { "lsp" },
          columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
        },
      },
      ghost_text = {
        enabled = true,
      },
    },

    signature = {
      enabled = true,
      window = {
        border = "rounded",
      },
    },
  },
  opts_extend = { "sources.default" },
  init = function()
    local autocmd = vim.api.nvim_create_autocmd
    local ui_helpers = vim.api.nvim_create_augroup("UiHelpers", { clear = true })

    -- disable buggy anims in completion windows
    autocmd("User", {
      group = ui_helpers,
      pattern = "BlinkCmpMenuOpen",
      callback = function()
        vim.g.snacks_animate = false
      end,
    })

    autocmd("User", {
      group = ui_helpers,
      pattern = "BlinkCmpMenuClose",
      callback = function()
        vim.g.snacks_animate = true
      end,
    })
  end,
}
