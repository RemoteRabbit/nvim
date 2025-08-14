;; sh
#!/bin/bash
# {{_file_name_}} - Environment setup script
# Author: {{_author_}}
# Date: {{_date_}}

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

log_info() {
    echo "✅ $1"
}

log_error() {
    echo "❌ $1" >&2
}

check_command() {
    if ! command -v "$1" &> /dev/null; then
        log_error "$1 is not installed"
        exit 1
    fi
    log_info "$1 is available"
}

install_dependencies() {
    log_info "Installing system dependencies..."

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get update
        sudo apt-get install -y {{_input_:linux_packages_}}
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            brew install {{_input_:mac_packages_}}
        else
            log_error "Homebrew not found. Please install Homebrew first."
            exit 1
        fi
    fi
}

setup_environment() {
    log_info "Setting up environment..."

    # Create necessary directories
    mkdir -p {{_input_:directories_}}

    # Copy configuration files
    if [[ -f "config/{{_input_:config_file_}}.example" ]]; then
        cp "config/{{_input_:config_file_}}.example" "config/{{_input_:config_file_}}"
        log_info "Created config/{{_input_:config_file_}} from example"
    fi

    # Set permissions
    chmod +x scripts/*.sh 2>/dev/null || true

    {{_cursor_}}
}

verify_setup() {
    log_info "Verifying setup..."

    # Check required commands
    check_command "{{_input_:required_command_}}"

    # Test configuration
    if [[ -f "config/{{_input_:config_file_}}" ]]; then
        log_info "Configuration file exists"
    else
        log_error "Configuration file missing"
        exit 1
    fi
}

main() {
    log_info "Starting environment setup for {{_input_:project_name_}}"

    install_dependencies
    setup_environment
    verify_setup

    log_info "Setup completed successfully! 🎉"
    echo ""
    echo "Next steps:"
    echo "  1. Review and update config/{{_input_:config_file_}}"
    echo "  2. Run: {{_input_:next_command_}}"
}

main "$@"
