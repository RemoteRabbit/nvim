#!/bin/bash
# Update README.md with enhanced content and plugin list

set -e

README="README.md"
PLUGINS_DIR="lua/plugins"

# Function to get neovim version requirement
get_nvim_version() {
    echo "0.10.0+"
}

# Function to count files of different types
count_stats() {
    local plugins=$(find "$PLUGINS_DIR" -name "*.lua" | wc -l)
    local configs=$(find lua/config -name "*.lua" 2>/dev/null | wc -l || echo 0)
    local templates=$(find templates -name "*" -type f 2>/dev/null | wc -l || echo 0)
    echo "📊 **Config Stats:** $plugins plugins • $configs core configs • $templates file templates"
}

# Create backup
cp "$README" "${README}.bak" 2>/dev/null || true

# Function to count plugins
count_plugins() {
    find "$PLUGINS_DIR" -name "*.lua" | wc -l
}

# Function to extract plugin names
get_plugin_list() {
    echo "<!-- AUTO-GENERATED PLUGIN LIST START -->"
    echo ""
    echo "### Installed Plugins ($(count_plugins) total)"
    echo ""

    # Group plugins by category based on filename
    declare -A categories

    for file in "$PLUGINS_DIR"/*.lua; do
        if [ -f "$file" ]; then
            filename=$(basename "$file" .lua)

            # Categorize based on filename patterns
            case "$filename" in
                *lsp*|*mason*|*language*) category="🔧 Language & LSP" ;;
                *git*|*fugitive*) category="📝 Git Integration" ;;
                *telescope*|*search*|*tree*) category="🔍 Navigation & Search" ;;
                *test*|*debug*|*dap*) category="🐛 Testing & Debugging" ;;
                *ui*|*theme*|*color*|*catppuccin*|*bufferline*|*lualine*) category="🎨 UI & Themes" ;;
                *treesitter*|*syntax*) category="🌳 Syntax & Parsing" ;;
                *completion*|*cmp*|*snippet*) category="💡 Completion" ;;
                *editor*|*autopair*|*surround*|*comment*) category="✏️ Editing" ;;
                *productivity*|*todo*|*bookmark*) category="📋 Productivity" ;;
                *terminal*|*tmux*) category="💻 Terminal" ;;
                *) category="🔌 Other Plugins" ;;
            esac

            # Extract main plugin repo from file
            main_plugin=$(grep -E '^\s*"[^/]+/[^"]+",?\s*$' "$file" | head -1 | sed 's/.*"\([^"]*\)".*/\1/' || echo "$filename")

            if [ ! -z "${categories[$category]}" ]; then
                categories[$category]="${categories[$category]}\n- [$main_plugin](https://github.com/$main_plugin)"
            else
                categories[$category]="- [$main_plugin](https://github.com/$main_plugin)"
            fi
        fi
    done

    # Output categorized plugins
    for category in "🔧 Language & LSP" "🎨 UI & Themes" "🔍 Navigation & Search" "💡 Completion" "✏️ Editing" "📝 Git Integration" "🐛 Testing & Debugging" "📋 Productivity" "🌳 Syntax & Parsing" "💻 Terminal" "🔌 Other Plugins"; do
        if [ ! -z "${categories[$category]}" ]; then
            echo "#### $category"
            echo ""
            echo -e "${categories[$category]}"
            echo ""
        fi
    done

    echo "<!-- AUTO-GENERATED PLUGIN LIST END -->"
}

# Update README with plugin list
if [ -f "$README" ]; then
    # Check if README has proper structure (not just plugin list)
    if ! grep -q "# 🚀 Personal Neovim Configuration" "$README"; then
        echo "Upgrading README to enhanced format..."
        # Backup and recreate with enhanced content
        mv "$README" "${README}.old"
        cat > "$README" << EOF
# 🚀 Personal Neovim Configuration

> A modern, feature-rich Neovim setup built for productivity and development workflow optimization.

$(count_stats)

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
- **Neovim $(get_nvim_version)** or later
- **Git** for plugin management
- **Node.js** for LSP servers
- **Python** and **pip** for additional tools
- **Ripgrep** for fast searching
- A [Nerd Font](https://www.nerdfonts.com/) for icons

### Quick Setup

\`\`\`bash
# Backup existing config (optional)
mv ~/.config/nvim ~/.config/nvim.backup

# Clone this configuration
git clone https://github.com/remoterabbit/nvim.git ~/.config/nvim

# Start Neovim (plugins will auto-install)
nvim
\`\`\`

## 📂 Structure

\`\`\`
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
\`\`\`

## 📚 Documentation

- **[Keybindings Reference](docs/KEYBINDINGS.md)** - Complete list of all keybindings organized by mode
- **[Plugin Documentation](docs/PLUGINS.md)** - Detailed information about each plugin
- **[Contributing Guidelines](.github/CONTRIBUTING.md)** - How to contribute to this configuration

## ⌨️ Key Mappings

### Leader Key: \`<space>\`

| Category | Key | Description |
|----------|-----|-------------|
| **Files** | \`<leader>ff\` | Find files |
| **Search** | \`<leader>fg\` | Live grep |
| **Git** | \`<leader>gg\` | LazyGit |
| **LSP** | \`<leader>ca\` | Code actions |
| **Debug** | \`<leader>dt\` | Toggle breakpoint |

> 💡 **Tip:** Press \`<space>\` in normal mode to see all available keybindings with which-key.

## 🔧 Customization

### Adding New Plugins

1. Create a new file in \`lua/plugins/\`
2. Follow the existing plugin structure
3. Run \`:Lazy\` to manage plugins

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
4. Run pre-commit hooks: \`pre-commit run --all-files\`
5. Submit a pull request

## 📄 License

This configuration is released into the public domain under the [Unlicense](LICENSE).

---

⭐ **Star this repo if you find it useful!**

EOF
        get_plugin_list >> "$README"
        echo "Enhanced README.md with comprehensive documentation"
    else
        # Just update plugin list in existing enhanced README
        sed '/<!-- AUTO-GENERATED PLUGIN LIST START -->/,/<!-- AUTO-GENERATED PLUGIN LIST END -->/d' "$README" > "${README}.tmp"
        echo "" >> "${README}.tmp"
        get_plugin_list >> "${README}.tmp"
        mv "${README}.tmp" "$README"
        echo "Updated plugin list in existing README.md"
    fi
else
    # Create new README if it doesn't exist
    cat > "$README" << EOF
# 🚀 Personal Neovim Configuration

> A modern, feature-rich Neovim setup built for productivity and development workflow optimization.

$(count_stats)

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
- **Neovim $(get_nvim_version)** or later
- **Git** for plugin management
- **Node.js** for LSP servers
- **Python** and **pip** for additional tools
- **Ripgrep** for fast searching
- A [Nerd Font](https://www.nerdfonts.com/) for icons

### Quick Setup

\`\`\`bash
# Backup existing config (optional)
mv ~/.config/nvim ~/.config/nvim.backup

# Clone this configuration
git clone https://github.com/remoterabbit/nvim.git ~/.config/nvim

# Start Neovim (plugins will auto-install)
nvim
\`\`\`

## 📂 Structure

\`\`\`
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
\`\`\`

## 📚 Documentation

- **[Keybindings Reference](docs/KEYBINDINGS.md)** - Complete list of all keybindings organized by mode
- **[Plugin Documentation](docs/PLUGINS.md)** - Detailed information about each plugin
- **[Contributing Guidelines](.github/CONTRIBUTING.md)** - How to contribute to this configuration

## ⌨️ Key Mappings

### Leader Key: \`<space>\`

| Category | Key | Description |
|----------|-----|-------------|
| **Files** | \`<leader>ff\` | Find files |
| **Search** | \`<leader>fg\` | Live grep |
| **Git** | \`<leader>gg\` | LazyGit |
| **LSP** | \`<leader>ca\` | Code actions |
| **Debug** | \`<leader>dt\` | Toggle breakpoint |

> 💡 **Tip:** Press \`<space>\` in normal mode to see all available keybindings with which-key.

## 🔧 Customization

### Adding New Plugins

1. Create a new file in \`lua/plugins/\`
2. Follow the existing plugin structure
3. Run \`:Lazy\` to manage plugins

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
4. Run pre-commit hooks: \`pre-commit run --all-files\`
5. Submit a pull request

## 📄 License

This configuration is released into the public domain under the [Unlicense](LICENSE).

---

⭐ **Star this repo if you find it useful!**

EOF

    get_plugin_list >> "$README"

    echo "Created enhanced README.md with full documentation"
fi

# Clean up
rm -f "${README}.bak"
