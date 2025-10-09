# 🚀 Personal Neovim Configuration

> A modern, feature-rich Neovim setup built for productivity and development workflow optimization.

📊 **Config Stats:** 54 plugins • 3 core configs • 9 file templates

## ✨ Key Features

### 🔧 Development Tools
- **Language Server Protocol (LSP)** - Full IDE-like features with auto-completion, diagnostics, and code actions
- **Debug Adapter Protocol (DAP)** - Integrated debugging support for multiple languages
- **Tree-sitter** - Advanced syntax highlighting and code understanding
- **Auto-formatting** - Code formatting with conform.nvim and language-specific tools
- **Linting** - Real-time code analysis and error detection

### 🎨 User Interface
- **Catppuccin Theme** - Beautiful, eye-friendly color scheme
- **Enhanced UI** - Custom statusline, bufferline, and floating windows
- **File Explorer** - Feature-rich nvim-tree with git integration
- **Fuzzy Finding** - Telescope for lightning-fast file and content search

### ⚡ Productivity
- **Git Integration** - Full git workflow with lazygit, gitsigns, and fugitive
- **Terminal Integration** - Seamless terminal and tmux navigation
- **Session Management** - Project-aware sessions and workspace restoration
- **Snippet System** - Extensive snippet collection for faster coding

### 🧪 Testing & Quality
- **Neotest** - Integrated test runner with language-specific adapters
- **Code Coverage** - Visual coverage indicators
- **Pre-commit Hooks** - Automated code quality checks and documentation generation

## 🛠️ Installation

### Prerequisites
- **Neovim 0.10.0+** or later
- **Git** for plugin management
- **Node.js** for LSP servers
- **Python** and **pip** for additional tools
- **Ripgrep** for fast searching
- A [Nerd Font](https://www.nerdfonts.com/) for icons

### Quick Setup

```bash
# Backup existing config (optional)
mv ~/.config/nvim ~/.config/nvim.backup

# Clone this configuration
git clone https://github.com/remoterabbit/nvim.git ~/.config/nvim

# Start Neovim (plugins will auto-install)
nvim
```

## 📂 Structure

```
~/.config/nvim/
├── 📁 lua/
│   ├── 📁 config/          # Core configuration
│   │   ├── options.lua     # Neovim options
│   │   ├── keymaps.lua     # Global keymaps
│   │   └── lazy.lua        # Plugin manager setup
│   └── 📁 plugins/         # Plugin configurations
├── 📁 docs/                # Auto-generated documentation
│   ├── KEYBINDINGS.md      # Comprehensive keybinding reference
│   └── PLUGINS.md          # Detailed plugin documentation
├── 📁 scripts/             # Automation scripts
├── 📁 templates/           # File templates
├── init.lua               # Entry point
└── stylua.toml           # Code formatting config
```

## 📚 Documentation

- **[Keybindings Reference](docs/KEYBINDINGS.md)** - Complete list of all keybindings organized by mode
- **[Plugin Documentation](docs/PLUGINS.md)** - Detailed information about each plugin
- **[Contributing Guidelines](.github/CONTRIBUTING.md)** - How to contribute to this configuration

## ⌨️ Key Mappings

### Leader Key: `<space>`

| Category | Key | Description |
|----------|-----|-------------|
| **Files** | `<leader>ff` | Find files |
| **Search** | `<leader>fg` | Live grep |
| **Git** | `<leader>gg` | LazyGit |
| **LSP** | `<leader>ca` | Code actions |
| **Debug** | `<leader>dt` | Toggle breakpoint |

> 💡 **Tip:** Press `<space>` in normal mode to see all available keybindings with which-key.

## 🔧 Customization

### Adding New Plugins

1. Create a new file in `lua/plugins/`
2. Follow the existing plugin structure
3. Run `:Lazy` to manage plugins

### Language Support

This configuration includes LSP support for:
- **Python** (Pyright)
- **JavaScript/TypeScript** (ts_ls)
- **Lua** (lua_ls)
- **Go** (gopls)
- **Rust** (rust-analyzer)
- **And many more...**

## 🤝 Contributing

Found a bug or want to add a feature? Contributions are welcome!

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run pre-commit hooks: `pre-commit run --all-files`
5. Submit a pull request

## 📄 License

This configuration is released into the public domain under the [Unlicense](LICENSE).

---

⭐ **Star this repo if you find it useful!**
























<!-- AUTO-GENERATED PLUGIN LIST START -->

### Installed Plugins (72 total)

#### 🔧 Language & LSP

- [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [onsails/lspkind.nvim](https://github.com/onsails/lspkind.nvim)
- [ray-x/lsp_signature.nvim](https://github.com/ray-x/lsp_signature.nvim)
- [williamboman/mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)
- [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim)

#### 🎨 UI & Themes

- [akinsho/bufferline.nvim](https://github.com/akinsho/bufferline.nvim)
- [catppuccin/nvim](https://github.com/catppuccin/nvim)
- [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
- [norcalli/nvim-colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua)
- [kristijanhusak/vim-dadbod-ui](https://github.com/kristijanhusak/vim-dadbod-ui)

#### 🔍 Navigation & Search

- [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [nvim-treesitter/nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
- [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [cappyzawa/telescope-terraform.nvim](https://github.com/cappyzawa/telescope-terraform.nvim)
- [mbbill/undotree](https://github.com/mbbill/undotree)

#### 💡 Completion

- [saghen/blink.cmp](https://github.com/saghen/blink.cmp)

#### ✏️ Editing

- [numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim)
- [](https://github.com/)
- [windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs)
- [kylechui/nvim-surround](https://github.com/kylechui/nvim-surround)
- [folke/todo-comments.nvim](https://github.com/folke/todo-comments.nvim)

#### 📝 Git Integration

- [harrisoncramer/gitlab.nvim](https://github.com/harrisoncramer/gitlab.nvim)
- [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)

#### 🐛 Testing & Debugging

- [nvim-neotest/neotest](https://github.com/nvim-neotest/neotest)
- [mfussenegger/nvim-dap](https://github.com/mfussenegger/nvim-dap)
- [mfussenegger/nvim-dap-python](https://github.com/mfussenegger/nvim-dap-python)

#### 💻 Terminal

- [christoomey/vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)

#### 🔌 Other Plugins

- [stevearc/aerial.nvim](https://github.com/stevearc/aerial.nvim)
- [laytan/cloak.nvim](https://github.com/laytan/cloak.nvim)
- [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim)
- [sindrets/diffview.nvim](https://github.com/sindrets/diffview.nvim)
- [elixir-tools/elixir-tools.nvim](https://github.com/elixir-tools/elixir-tools.nvim)
- [allaman/emoji.nvim](https://github.com/allaman/emoji.nvim)
- [j-hui/fidget.nvim](https://github.com/j-hui/fidget.nvim)
- [ray-x/go.nvim](https://github.com/ray-x/go.nvim)
- [ThePrimeagen/harpoon](https://github.com/ThePrimeagen/harpoon)
- [mistweaverco/kulala.nvim](https://github.com/mistweaverco/kulala.nvim)
- [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip)
- [karb94/neoscroll.nvim](https://github.com/karb94/neoscroll.nvim)
- [saxon1964/neovim-tips](https://github.com/saxon1964/neovim-tips)
- [andythigpen/nvim-coverage](https://github.com/andythigpen/nvim-coverage)
- [warpaint9299/nvim-devdocs](https://github.com/warpaint9299/nvim-devdocs)
- [gennaro-tedesco/nvim-jqx](https://github.com/gennaro-tedesco/nvim-jqx)
- [mfussenegger/nvim-lint](https://github.com/mfussenegger/nvim-lint)
- [paretje/nvim-man](https://github.com/paretje/nvim-man)
- [SmiteshP/nvim-navic](https://github.com/SmiteshP/nvim-navic)
- [michaelrommel/nvim-silicon](https://github.com/michaelrommel/nvim-silicon)
- [kevinhwang91/nvim-ufo](https://github.com/kevinhwang91/nvim-ufo)
- [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)
- [epwalsh/obsidian.nvim](https://github.com/epwalsh/obsidian.nvim)
- [pwntester/octo.nvim](https://github.com/pwntester/octo.nvim)
- [hedyhli/outline.nvim](https://github.com/hedyhli/outline.nvim)
- [stevearc/overseer.nvim](https://github.com/stevearc/overseer.nvim)
- [vuki656/package-info.nvim](https://github.com/vuki656/package-info.nvim)
- [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [stevearc/profile.nvim](https://github.com/stevearc/profile.nvim)
- [ThePrimeagen/refactoring.nvim](https://github.com/ThePrimeagen/refactoring.nvim)
- [MeanderingProgrammer/render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)
- [b0o/schemastore.nvim](https://github.com/b0o/schemastore.nvim)
- [LintaoAmons/scratch.nvim](https://github.com/LintaoAmons/scratch.nvim)
- [m4xshen/smartcolumn.nvim](https://github.com/m4xshen/smartcolumn.nvim)
- [mrjones2014/smart-splits.nvim](https://github.com/mrjones2014/smart-splits.nvim)
- [folke/snacks.nvim](https://github.com/folke/snacks.nvim)
- [nvim-pack/nvim-spectre](https://github.com/nvim-pack/nvim-spectre)
- [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [folke/trouble.nvim](https://github.com/folke/trouble.nvim)
- [linux-cultist/venv-selector.nvim](https://github.com/linux-cultist/venv-selector.nvim)
- [RRethy/vim-illuminate](https://github.com/RRethy/vim-illuminate)
- [dhruvasagar/vim-table-mode](https://github.com/dhruvasagar/vim-table-mode)
- [wakatime/vim-wakatime](https://github.com/wakatime/vim-wakatime)
- [folke/which-key.nvim](https://github.com/folke/which-key.nvim)

<!-- AUTO-GENERATED PLUGIN LIST END -->
