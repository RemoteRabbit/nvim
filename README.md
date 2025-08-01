# RemoteRabbit NeoVim Configuration

A modern NeoVim configuration using [Lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager.

## Features

- LSP integration with Mason for easy language server management
- Fuzzy finding with Telescope
- Git integration with Gitsigns and Lazygit
- File tree with nvim-tree
- Syntax highlighting with Treesitter
- Code completion with nvim-cmp
- Debugging support with nvim-dap
- Markdown rendering and note-taking with Obsidian
- Code formatting and linting
- Beautiful UI with Catppuccin theme

## Installation

### Standard Installation

```shell
git clone https://github.com/remoterabbit/nvim $HOME/.config/nvim
```

### My Personal Setup

```shell
mkdir -p $HOME/repos/personal
git clone https://github.com/remoterabbit/nvim $HOME/repos/personal/nvim
ln -sf $HOME/repos/personal/nvim $HOME/.config/nvim
```

### Standalone Installation (No Git)

```shell
git clone https://github.com/remoterabbit/nvim $HOME/.config/nvim
rm -rf $HOME/.config/nvim/.git
```

## Post-Installation

After cloning and launching NeoVim:

1. Lazy.nvim will automatically install all plugins
2. Run `:checkhealth` to verify everything is working correctly
3. Install any missing dependencies as suggested by checkhealth

## Plugin Overview

| Plugin | Description |
| ------ | ----------- |
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Modern plugin manager for NeoVim |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder for files, buffers, grep, and more |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting and code parsing |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | Language Server Protocol configuration |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | Package manager for LSP servers, DAP servers, linters, and formatters |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Auto-completion engine |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git integration with signs, hunks, and blame |
| [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) | File explorer tree |
| [harpoon](https://github.com/ThePrimeagen/harpoon) | Quick file navigation and marking |
| [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim) | Lazygit integration for advanced git operations |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Displays available keybindings in popup |
| [catppuccin](https://github.com/catppuccin/nvim) | Soothing pastel theme |
| [nvim-dap](https://github.com/mfussenegger/nvim-dap) | Debug Adapter Protocol client |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Lightweight formatter plugin |
| [trouble.nvim](https://github.com/folke/trouble.nvim) | Pretty list for diagnostics, references, and more |
| [obsidian.nvim](https://github.com/epwalsh/obsidian.nvim) | Obsidian vault integration for note-taking |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | Markdown rendering with enhanced visuals |
| [nvim-spectre](https://github.com/nvim-pack/nvim-spectre) | Find and replace panel |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | Highlight and search TODO comments |
| [undotree](https://github.com/mbbill/undotree) | Visualize undo history |
| [autopairs](https://github.com/windwp/nvim-autopairs) | Auto-close brackets, quotes, etc. |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Indentation guides |
| [satellite.nvim](https://github.com/lewis6991/satellite.nvim) | Scrollbar with git and diagnostic info |
| [twilight.nvim](https://github.com/folke/twilight.nvim) | Dims inactive portions of code |
| [cloak.nvim](https://github.com/laytan/cloak.nvim) | Hide/show secrets and sensitive information |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | Seamless navigation between tmux panes and vim splits |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim) | Smart commenting with treesitter integration |
| [snacks.nvim](https://github.com/folke/snacks.nvim) | Collection of small QoL plugins |
| [refactoring.nvim](https://github.com/ThePrimeagen/refactoring.nvim) | Code refactoring tools |
| [octo.nvim](https://github.com/pwntester/octo.nvim) | GitHub integration for issues and PRs |

## Key Features

### LSP & Development
- Full LSP support with auto-completion, diagnostics, and formatting
- Debugging with DAP for multiple languages
- Code actions and refactoring tools
- Integrated terminal and git workflows

### File Management
- Fast file finding with Telescope
- Project-wide search and replace
- Quick file navigation with Harpoon
- File tree browser with git integration

### Writing & Documentation
- Obsidian vault integration for note-taking
- Enhanced markdown rendering
- Table editing mode
- TODO comment highlighting

### UI & Experience
- Beautiful Catppuccin theme
- Indentation guides and scrollbar
- Which-key for discoverable keybindings
- Twilight mode for focused editing

## Configuration Structure

```
nvim/
├── init.lua              # Entry point
├── lua/
│   ├── config/           # Core configuration
│   │   ├── lazy.lua      # Lazy.nvim setup
│   │   ├── options.lua   # NeoVim options
│   │   └── keymaps.lua   # Key mappings
│   └── plugins/          # Plugin configurations
└── lazy-lock.json        # Plugin version lock file
```

## Resources

- [Mason Registry](https://mason-registry.dev/registry/list) - Available LSP servers and tools
- [Lazy.nvim Documentation](https://lazy.folke.io/) - Plugin manager documentation
- [NeoVim Documentation](https://neovim.io/doc/) - Official NeoVim docs

## Key Mapping Note

`<CR>` in key mappings refers to the RETURN/ENTER key press.
