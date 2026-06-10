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

### Automated Setup (recommended)

The [`install.sh`](install.sh) script bootstraps everything on a fresh machine.
It is interactive and supports **macOS**, **Arch Linux**, and **Debian/Ubuntu**.

```bash
# Clone this configuration
git clone https://github.com/remoterabbit/nvim.git ~/.config/nvim
cd ~/.config/nvim

# Run the installer (or: make install)
./install.sh
```

The installer will, with prompts along the way:

1. Detect your operating system.
2. Install system dependencies (Neovim, ripgrep, fd, fzf, language toolchains,
   LSP/formatter tools, a Nerd Font, etc.) via your package manager plus `pipx`
   and `npm`.
3. Back up any existing `~/.config/nvim` to a timestamped directory.
4. Symlink this repository to `~/.config/nvim`.
5. Install plugins with lazy.nvim.
6. Install and register the pre-commit hooks.

> **Note:** the installer uses `sudo` for system packages and for symlinks under
> `/usr/local/bin`. On unsupported systems, install the prerequisites manually
> and use the manual setup below.

### Manual Setup

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

### Installed Plugins (59 total)

#### 🔧 Language & LSP

- [mason-org/mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim)
- [mason-org/mason.nvim](https://github.com/mason-org/mason.nvim)
- [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [onsails/lspkind.nvim](https://github.com/onsails/lspkind.nvim)
- [ray-x/lsp_signature.nvim](https://github.com/ray-x/lsp_signature.nvim)

#### 🎨 UI & Themes

- [NvChad/nvim-colorizer.lua](https://github.com/NvChad/nvim-colorizer.lua)
- [catppuccin/nvim](https://github.com/catppuccin/nvim)
- [kristijanhusak/vim-dadbod-ui](https://github.com/kristijanhusak/vim-dadbod-ui)
- [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)

#### 🔍 Navigation & Search

- [mbbill/undotree](https://github.com/mbbill/undotree)
- [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [nvim-treesitter/nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)

#### 💡 Completion

- [saghen/blink.cmp](https://github.com/saghen/blink.cmp)

#### ✏️ Editing

- [folke/todo-comments.nvim](https://github.com/folke/todo-comments.nvim)
- [kylechui/nvim-surround](https://github.com/kylechui/nvim-surround)
- [windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs)

#### 📝 Git Integration

- [harrisoncramer/gitlab.nvim](https://github.com/harrisoncramer/gitlab.nvim)
- [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)

#### 🐛 Testing & Debugging

- [leoluz/nvim-dap-go](https://github.com/leoluz/nvim-dap-go)
- [mfussenegger/nvim-dap](https://github.com/mfussenegger/nvim-dap)
- [mfussenegger/nvim-dap-python](https://github.com/mfussenegger/nvim-dap-python)
- [nvim-neotest/neotest](https://github.com/nvim-neotest/neotest)

#### 🔌 Other Plugins

- [MeanderingProgrammer/render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)
- [RRethy/vim-illuminate](https://github.com/RRethy/vim-illuminate)
- [SmiteshP/nvim-navic](https://github.com/SmiteshP/nvim-navic)
- [ThePrimeagen/harpoon](https://github.com/ThePrimeagen/harpoon)
- [ThePrimeagen/refactoring.nvim](https://github.com/ThePrimeagen/refactoring.nvim)
- [allaman/emoji.nvim](https://github.com/allaman/emoji.nvim)
- [andythigpen/nvim-coverage](https://github.com/andythigpen/nvim-coverage)
- [chrisgrieser/nvim-scissors](https://github.com/chrisgrieser/nvim-scissors)
- [dhruvasagar/vim-table-mode](https://github.com/dhruvasagar/vim-table-mode)
- [elixir-tools/elixir-tools.nvim](https://github.com/elixir-tools/elixir-tools.nvim)
- [folke/snacks.nvim](https://github.com/folke/snacks.nvim)
- [folke/trouble.nvim](https://github.com/folke/trouble.nvim)
- [folke/which-key.nvim](https://github.com/folke/which-key.nvim)
- [gennaro-tedesco/nvim-jqx](https://github.com/gennaro-tedesco/nvim-jqx)
- [j-hui/fidget.nvim](https://github.com/j-hui/fidget.nvim)
- [karb94/neoscroll.nvim](https://github.com/karb94/neoscroll.nvim)
- [kevinhwang91/nvim-ufo](https://github.com/kevinhwang91/nvim-ufo)
- [laytan/cloak.nvim](https://github.com/laytan/cloak.nvim)
- [m4xshen/smartcolumn.nvim](https://github.com/m4xshen/smartcolumn.nvim)
- [mfussenegger/nvim-lint](https://github.com/mfussenegger/nvim-lint)
- [michaelrommel/nvim-silicon](https://github.com/michaelrommel/nvim-silicon)
- [mistweaverco/kulala.nvim](https://github.com/mistweaverco/kulala.nvim)
- [mrjones2014/smart-splits.nvim](https://github.com/mrjones2014/smart-splits.nvim)
- [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [nvim-pack/nvim-spectre](https://github.com/nvim-pack/nvim-spectre)
- [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)
- [paretje/nvim-man](https://github.com/paretje/nvim-man)
- [pwntester/octo.nvim](https://github.com/pwntester/octo.nvim)
- [ray-x/go.nvim](https://github.com/ray-x/go.nvim)
- [remoterabbit/pr-description.nvim](https://github.com/remoterabbit/pr-description.nvim)
- [sindrets/diffview.nvim](https://github.com/sindrets/diffview.nvim)
- [stevearc/aerial.nvim](https://github.com/stevearc/aerial.nvim)
- [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim)
- [stevearc/overseer.nvim](https://github.com/stevearc/overseer.nvim)
- [stevearc/profile.nvim](https://github.com/stevearc/profile.nvim)
- [vuki656/package-info.nvim](https://github.com/vuki656/package-info.nvim)

<!-- AUTO-GENERATED PLUGIN LIST END -->
