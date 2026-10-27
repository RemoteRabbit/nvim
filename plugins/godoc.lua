return {
  src = "https://github.com/fredrikaverpil/godoc.nvim",
  version = vim.version.range("*"),
  config = function()
    require("godoc").setup({
      adapters = {
        {
          name = "go",
          opts = {
            command = "GoDoc",
            get_syntax_info = function()
              return {
                filetype = "godoc",
                language = "godoc",
              }
            end,
          },
        },
      },
      window = {
        type = "split",
      },
      picker = {
        type = "snacks",
        snacks = {},
      },
    })
  end,

  vim.api.nvim_set_keymap("n", "<leader>Gd", "<CMD>GoDoc<CR>", { desc = "Search GoDoc" }),

  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      if ev.data.spec.name == "godoc.nvim" and (ev.data.kind == "install" or ev.data.kind == "update") then
        vim
          .system({
            "go",
            "install",
            "github.com/lotusirous/gostdsym/stdsym@latest",
          })
          :wait()
      end
    end,
  }),
}
