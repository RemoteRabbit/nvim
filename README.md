# nvim setup

This repository contains the configuration and plugins for my Neovim editor. The setup is designed to provide a highly customizable and efficient development environment tailored to various programming languages and tasks.

## Features

- **Language Server Protocol (LSP)**: Integrated LSP support with multiple language servers for enhanced code intelligence, diagnostics, and auto-completion.
- **Snippets**: Utilizes LuaSnip for snippet management, allowing for quick and efficient coding through pre-defined templates.
- **Version Control Integration**: Gitsigns provides visual indications of changes in the gutter, making it easier to track modifications.
- **Auto Formatting**: Conform.nvim automatically formats code on save, ensuring consistent styling across different file types.
- **Keymaps**: Custom keybindings for quick access to frequently used commands and plugins.
- **Dashboard**: A customizable dashboard with recent files, git status, and other useful information.

## Installation

1. Clone the repository:

   ```sh
   git clone https://github.com/yourusername/nvim-setup.git ~/.config/nvim
   ```

2. Start Neovim and enjoy your customized setup.

## Configuration

The configuration is split into multiple Lua files located in the `lua` directory. You can customize the settings by editing these files or adding your own configurations.

## License

This project is licensed under the Unlicense - see the [LICENSE](LICENSE) file for details.
