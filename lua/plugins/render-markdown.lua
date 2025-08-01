return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { 
    "nvim-treesitter/nvim-treesitter",
    "echasnovski/mini.nvim", -- for icons
  },
  ft = { "markdown", "norg", "rmd", "org" },
  opts = {
    heading = {
      enabled = true,
      sign = true,
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      position = "overlay",
      width = "full",
      left_margin = 0,
      left_pad = 0,
      right_pad = 0,
      min_width = 0,
      border = false,
      border_virtual = false,
      above = "▄",
      below = "▀",
      backgrounds = {
        "RenderMarkdownH1Bg",
        "RenderMarkdownH2Bg",
        "RenderMarkdownH3Bg",
        "RenderMarkdownH4Bg",
        "RenderMarkdownH5Bg",
        "RenderMarkdownH6Bg",
      },
      foregrounds = {
        "RenderMarkdownH1",
        "RenderMarkdownH2", 
        "RenderMarkdownH3",
        "RenderMarkdownH4",
        "RenderMarkdownH5",
        "RenderMarkdownH6",
      },
    },
    paragraph = {
      enabled = true,
      left_margin = 0,
      min_width = 0,
    },
    code = {
      enabled = true,
      sign = false,
      style = "full",
      position = "left",
      language_pad = 0,
      disable_background = { "diff" },
      width = "full",
      left_margin = 0,
      left_pad = 0,
      right_pad = 0,
      min_width = 0,
      border = "thin",
      above = "▄",
      below = "▀",
      highlight = "RenderMarkdownCode",
      highlight_inline = "RenderMarkdownCodeInline",
    },
    dash = {
      enabled = true,
      icon = "─",
      width = "full",
      highlight = "RenderMarkdownDash",
    },
    bullet = {
      enabled = true,
      icons = { "●", "○", "◆", "◇" },
      left_pad = 0,
      right_pad = 0,
      highlight = "RenderMarkdownBullet",
    },
    checkbox = {
      enabled = true,
      position = "inline",
      unchecked = {
        icon = "󰄱 ",
        highlight = "RenderMarkdownUnchecked",
      },
      checked = {
        icon = "󰱒 ",
        highlight = "RenderMarkdownChecked",
      },
      custom = {
        todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
      },
    },
    quote = {
      enabled = true,
      icon = "▋",
      repeat_linebreak = false,
      highlight = "RenderMarkdownQuote",
    },
    pipe_table = {
      enabled = true,
      preset = "none",
      style = "full",
      cell = "padded",
      min_width = 0,
      border = {
        "┌", "┬", "┐",
        "├", "┼", "┤", 
        "└", "┴", "┘",
        "│", "─",
      },
      alignment_indicator = "━",
      head = "RenderMarkdownTableHead",
      row = "RenderMarkdownTableRow",
      filler = "RenderMarkdownTableFill",
    },
    callout = {
      note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
      tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
      important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
      warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
      caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
    },
    link = {
      enabled = true,
      image = "󰥶 ",
      email = "󰀓 ",
      hyperlink = "󰌹 ",
      highlight = "RenderMarkdownLink",
      custom = {
        web = { pattern = "^http[s]?://", icon = "󰖟 ", highlight = "RenderMarkdownLink" },
      },
    },
    sign = {
      enabled = true,
      highlight = "RenderMarkdownSign",
    },
    math = {
      enabled = true,
      inline = "$",
      block = "$$",
      highlight = "RenderMarkdownMath",
    },
  },
  config = function(_, opts)
    require("render-markdown").setup(opts)
    
    -- Toggle rendering
    vim.keymap.set("n", "<leader>mr", ":RenderMarkdown toggle<CR>", { desc = "Toggle Markdown Rendering" })
    
    -- Enable by default for markdown files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        vim.cmd("RenderMarkdown enable")
      end,
    })
  end,
}
