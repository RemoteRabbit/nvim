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

### Installed Plugins (54 total)

#### 🔧 Language & LSP

- [hashivim/vim-terraform](https://github.com/hashivim/vim-terraform)
- [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [RRethy/vim-illuminate](https://github.com/RRethy/vim-illuminate)
- [onsails/lspkind.nvim](https://github.com/onsails/lspkind.nvim)
- [j-hui/fidget.nvim](https://github.com/j-hui/fidget.nvim)
- [williamboman/mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)
- [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim)

#### 🎨 UI & Themes

- [catppuccin/nvim](https://github.com/catppuccin/nvim)
- [norcalli/nvim-colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua)
- [stevearc/dressing.nvim](https://github.com/stevearc/dressing.nvim)
- [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)

#### 🔍 Navigation & Search

- [nvim-pack/nvim-spectre](https://github.com/nvim-pack/nvim-spectre)
- [nvim-tree/nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua)
- [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [mbbill/undotree](https://github.com/mbbill/undotree)

#### ✏️ Editing

- [windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs)
- [numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim)
- [mg979/vim-visual-multi](https://github.com/mg979/vim-visual-multi)
- [folke/todo-comments.nvim](https://github.com/folke/todo-comments.nvim)

#### 📝 Git Integration

- [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [kdheepak/lazygit.nvim](https://github.com/kdheepak/lazygit.nvim)

#### 🐛 Testing & Debugging

- [mfussenegger/nvim-dap](https://github.com/mfussenegger/nvim-dap)
- [nvim-neotest/neotest](https://github.com/nvim-neotest/neotest)

#### 📋 Productivity

- [MattesGroeger/vim-bookmarks](https://github.com/MattesGroeger/vim-bookmarks)
- [nvim-neorg/neorg](https://github.com/nvim-neorg/neorg)

#### 💻 Terminal

- [christoomey/vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)

#### 🔌 Other Plugins

- [laytan/cloak.nvim](https://github.com/laytan/cloak.nvim)
- [mfussenegger/nvim-lint](https://github.com/mfussenegger/nvim-lint)
- [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim)
- [akinsho/toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)
- [folke/trouble.nvim](https://github.com/folke/trouble.nvim)
- [stevearc/dressing.nvim](https://github.com/stevearc/dressing.nvim)
- [glepnir/template.nvim](https://github.com/glepnir/template.nvim)
- [ThePrimeagen/harpoon](https://github.com/ThePrimeagen/harpoon)
- [lukas-reineke/indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)
- [paretje/nvim-man](https://github.com/paretje/nvim-man)
- [epwalsh/obsidian.nvim](https://github.com/epwalsh/obsidian.nvim)
- [pwntester/octo.nvim](https://github.com/pwntester/octo.nvim)
- [hedyhli/outline.nvim](https://github.com/hedyhli/outline.nvim)
- [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [ThePrimeagen/refactoring.nvim](https://github.com/ThePrimeagen/refactoring.nvim)
- [MeanderingProgrammer/render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)
- [lewis6991/satellite.nvim](https://github.com/lewis6991/satellite.nvim)
- [mrjones2014/smart-splits.nvim](https://github.com/mrjones2014/smart-splits.nvim)
- [folke/snacks.nvim](https://github.com/folke/snacks.nvim)
- [nvim-pack/nvim-spectre](https://github.com/nvim-pack/nvim-spectre)
- [folke/trouble.nvim](https://github.com/folke/trouble.nvim)
- [folke/twilight.nvim](https://github.com/folke/twilight.nvim)
- [dhruvasagar/vim-table-mode](https://github.com/dhruvasagar/vim-table-mode)
- [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)
- [folke/which-key.nvim](https://github.com/folke/which-key.nvim)
- [folke/zen-mode.nvim](https://github.com/folke/zen-mode.nvim)

<!-- AUTO-GENERATED PLUGIN LIST END -->
