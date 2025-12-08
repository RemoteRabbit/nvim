#!/usr/bin/env bash

set -e

NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ -f /etc/arch-release ]]; then
        echo "arch"
    elif [[ -f /etc/debian_version ]]; then
        echo "debian"
    else
        echo "unknown"
    fi
}

check_command() {
    if command -v "$1" &> /dev/null; then
        log_success "$1 is installed"
        return 0
    else
        log_warning "$1 is not installed"
        return 1
    fi
}

install_dependencies() {
    local os="$1"
    log_info "Installing dependencies for $os..."

    case "$os" in
        arch)
            log_info "Updating system packages..."
            sudo pacman -Syu --noconfirm

            log_info "Installing required packages..."

            # Check if any nodejs variant is installed
            if ! pacman -Qq | grep -q '^nodejs'; then
                NODEJS_PKG="nodejs npm"
            else
                log_info "Node.js already installed, skipping..."
                NODEJS_PKG=""
            fi

            # Check if tfenv is installed (skip terraform if so)
            if pacman -Qq tfenv &> /dev/null; then
                log_info "tfenv detected, skipping terraform package..."
                TERRAFORM_PKG=""
            else
                TERRAFORM_PKG="terraform"
            fi

            sudo pacman -S --needed --noconfirm \
                neovim \
                git \
                base-devel \
                curl \
                wget \
                ripgrep \
                fd \
                fzf \
                $NODEJS_PKG \
                python \
                python-pip \
                luarocks \
                tree-sitter \
                unzip \
                gzip \
                tar \
                jq \
                shellcheck \
                shfmt \
                stylua \
                go \
                rust \
                elixir \
                erlang \
                $TERRAFORM_PKG

            log_info "Installing GitHub CLI, GitLab CLI, and dev tools..."
            sudo pacman -S --needed --noconfirm \
                github-cli \
                rebar3 \
                silicon \
                yamllint \
                golangci-lint

            if command -v yay &> /dev/null || command -v paru &> /dev/null; then
                local aur_helper="yay"
                command -v paru &> /dev/null && aur_helper="paru"

                log_info "Installing AUR packages..."
                $aur_helper -S --needed --noconfirm \
                    lazygit \
                    glab \
                    hadolint-bin \
                    tfenv \
                    ttf-nerd-fonts-symbols-mono || log_warning "Some AUR packages may have failed"
            else
                log_warning "No AUR helper found. Install lazygit, glab, hadolint, tfenv, and nerd fonts manually."
            fi
            ;;

        debian)
            log_info "Updating system packages..."
            sudo apt update

            log_info "Installing required packages..."
            sudo apt install -y \
                git \
                build-essential \
                curl \
                wget \
                ripgrep \
                fd-find \
                fzf \
                nodejs \
                npm \
                python3 \
                python3-pip \
                python3-venv \
                luarocks \
                unzip \
                gzip \
                tar \
                jq \
                shellcheck \
                golang-go \
                elixir \
                erlang \
                yamllint

            log_info "Installing/upgrading Neovim..."
            if ! check_command nvim || [[ $(nvim --version | head -n1 | grep -oP 'v\K[0-9]+\.[0-9]+' | awk '{print ($1 >= 0.10)}') != "1" ]]; then
                log_info "Installing Neovim from GitHub releases..."
                NVIM_VERSION="stable"
                curl -LO "https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/nvim-linux64.tar.gz"
                sudo tar -C /opt -xzf nvim-linux64.tar.gz
                sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
                rm nvim-linux64.tar.gz
            fi

            log_info "Installing lazygit..."
            LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
            curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
            tar xf lazygit.tar.gz lazygit
            sudo install lazygit /usr/local/bin
            rm lazygit lazygit.tar.gz

            log_info "Installing GitHub CLI..."
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
            sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            sudo apt update
            sudo apt install -y gh

            log_info "Installing GitLab CLI..."
            GLAB_VERSION=$(curl -s "https://api.github.com/repos/profclems/glab/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
            curl -Lo glab.tar.gz "https://github.com/profclems/glab/releases/latest/download/glab_${GLAB_VERSION}_Linux_x86_64.tar.gz"
            tar xf glab.tar.gz bin/glab
            sudo install bin/glab /usr/local/bin
            rm -rf glab.tar.gz bin

            log_info "Installing rebar3 (Erlang/Elixir build tool)..."
            curl -Lo rebar3 https://s3.amazonaws.com/rebar3/rebar3
            chmod +x rebar3
            sudo mv rebar3 /usr/local/bin/

            log_info "Installing tfenv..."
            git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv
            sudo ln -sf ~/.tfenv/bin/* /usr/local/bin

            log_info "Installing Rust..."
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
            source "$HOME/.cargo/env"

            log_info "Installing additional tools via cargo and go..."
            cargo install stylua silicon
            go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
            go install mvdan.cc/sh/v3/cmd/shfmt@latest

            if ! command -v tfenv &> /dev/null; then
                log_info "Installing Terraform..."
                wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
                echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
                sudo apt update && sudo apt install -y terraform
            else
                log_info "tfenv detected, skipping terraform installation..."
            fi

            log_info "Installing Terraform tools..."
            curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
            curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash

            log_info "Installing Hadolint..."
            wget -O /tmp/hadolint https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64
            chmod +x /tmp/hadolint
            sudo mv /tmp/hadolint /usr/local/bin/hadolint

            log_info "Installing yamlfmt and other formatters..."
            go install github.com/google/yamlfmt/cmd/yamlfmt@latest
            npm install -g markdownlint-cli jsonlint

            log_warning "Install a Nerd Font manually from https://www.nerdfonts.com/"
            ;;

        macos)
            if ! check_command brew; then
                log_info "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi

            log_info "Installing required packages..."

            # Build package list, install tfenv instead of terraform
            PACKAGES="neovim git ripgrep fd fzf node python3 luarocks tree-sitter lazygit gh glab rebar3 jq shellcheck shfmt stylua go rust elixir erlang silicon hadolint tflint tfsec yamllint golangci-lint yamlfmt markdownlint-cli jsonlint tfenv"

            brew install $PACKAGES

            log_info "Installing Nerd Font..."
            brew tap homebrew/cask-fonts
            brew install --cask font-jetbrains-mono-nerd-font || log_warning "Nerd font installation failed"
            ;;

        *)
            log_error "Unsupported OS. Please install dependencies manually."
            exit 1
            ;;
    esac

    log_info "Installing Python packages..."
    local os=$(detect_os)

    # Ensure pipx is installed
    if ! command -v pipx &> /dev/null; then
        log_info "Installing pipx..."
        case "$os" in
            arch)
                sudo pacman -S --needed --noconfirm python-pipx
                ;;
            debian)
                sudo apt install -y python3-pipx
                ;;
            macos)
                brew install pipx
                ;;
        esac
        pipx ensurepath
    fi

    # Install libraries needed by neovim
    if [[ "$os" == "arch" ]]; then
        sudo pacman -S --needed --noconfirm python-pynvim python-debugpy
    else
        python3 -m pip install --user --upgrade pynvim debugpy
    fi

    # Install CLI tools via pipx on all platforms
    log_info "Installing Python CLI tools via pipx..."
    pipx install ruff || pipx upgrade ruff || log_warning "ruff installation failed"
    pipx install mypy || pipx upgrade mypy || log_warning "mypy installation failed"
    pipx install pytest || pipx upgrade pytest || log_warning "pytest installation failed"
    pipx install codespell || pipx upgrade codespell || log_warning "codespell installation failed"

    log_info "Installing Node packages..."
    npm install -g neovim tree-sitter-cli

    log_success "Dependencies installed successfully!"
}

backup_existing_config() {
    if [[ -d "$NVIM_CONFIG_DIR" ]] && [[ "$NVIM_CONFIG_DIR" != "$SCRIPT_DIR" ]]; then
        local backup_dir="${NVIM_CONFIG_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
        log_warning "Existing config found at $NVIM_CONFIG_DIR"
        log_info "Creating backup at $backup_dir"
        mv "$NVIM_CONFIG_DIR" "$backup_dir"
        log_success "Backup created"
    fi
}

link_config() {
    if [[ "$SCRIPT_DIR" != "$NVIM_CONFIG_DIR" ]]; then
        log_info "Linking config to $NVIM_CONFIG_DIR"
        mkdir -p "$(dirname "$NVIM_CONFIG_DIR")"
        ln -sf "$SCRIPT_DIR" "$NVIM_CONFIG_DIR"
        log_success "Config linked"
    else
        log_info "Already in config directory, skipping link"
    fi
}

install_plugins() {
    log_info "Installing Neovim plugins..."
    nvim --headless "+Lazy! sync" +qa
    log_success "Plugins installed!"
}

setup_pre_commit() {
    if [[ -f "$SCRIPT_DIR/.pre-commit-config.yaml" ]]; then
        log_info "Setting up pre-commit hooks..."

        # Use pipx for pre-commit on all platforms
        pipx install pre-commit || pipx upgrade pre-commit || log_warning "Pre-commit installation failed"

        cd "$SCRIPT_DIR"
        pre-commit install || log_warning "Pre-commit setup failed"
    fi
}

print_summary() {
    echo ""
    log_success "═══════════════════════════════════════"
    log_success "  Neovim configuration installed! 🚀"
    log_success "═══════════════════════════════════════"
    echo ""
    log_info "Next steps:"
    echo "  1. Close and reopen your terminal"
    echo "  2. Run: nvim"
    echo "  3. Wait for plugins to finish installing"
    echo "  4. Run :checkhealth to verify setup"
    echo ""
    log_info "Useful commands:"
    echo "  :Lazy        - Manage plugins"
    echo "  :Mason       - Manage LSP servers"
    echo "  <space>      - Show keybindings"
    echo ""
}

main() {
    echo ""
    log_info "═══════════════════════════════════════"
    log_info "  Neovim Configuration Installer"
    log_info "═══════════════════════════════════════"
    echo ""

    OS=$(detect_os)
    log_info "Detected OS: $OS"
    echo ""

    if [[ "$OS" == "unknown" ]]; then
        log_error "Unsupported operating system"
        exit 1
    fi

    read -p "Install dependencies? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_dependencies "$OS"
    fi

    backup_existing_config
    link_config

    read -p "Install plugins now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_plugins
    fi

    setup_pre_commit

    print_summary
}

main "$@"
