return {
  "SmiteshP/nvim-navic",
  config = function()
    local navic = require("nvim-navic")
    navic.setup({
      icons = {
        File = "󰈙 ",
        Module = " ",
        Namespace = "󰌗 ",
        Package = " ",
        Class = "󰌗 ",
        Method = "󰆧 ",
        Property = " ",
        Field = " ",
        Constructor = " ",
        Enum = "󰕘",
        Interface = "󰕘",
        Function = "󰊕 ",
        Variable = "󰆧 ",
        Constant = "󰏿 ",
        String = "󰀬 ",
        Number = "󰎠 ",
        Boolean = "◩ ",
        Array = "󰅪 ",
        Object = "󰅩 ",
        Key = "󰌋 ",
        Null = "󰟢 ",
        EnumMember = " ",
        Struct = "󰌗 ",
        Event = " ",
        Operator = "󰆕 ",
        TypeParameter = "󰊄 ",
      },
      lsp = {
        auto_attach = true,
        preference = nil,
      },
      highlight = false,
      separator = " > ",
      depth_limit = 0,
      depth_limit_indicator = "..",
      safe_output = true,
      lazy_update_context = false,
      click = false,
    })

    -- Attach navic to LSP
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.server_capabilities.documentSymbolProvider then
          navic.attach(client, args.buf)
        end
      end,
    })

    -- Show breadcrumbs in winbar
    vim.api.nvim_create_autocmd({ "CursorMoved", "BufEnter" }, {
      callback = function()
        if navic.is_available() then
          vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
        end
      end,
    })
  end,
}
