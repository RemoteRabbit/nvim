;; sh
#!/bin/bash
# {{_file_name_}} - Deployment script
# Author: {{_author_}}
# Date: {{_date_}}

set -euo pipefail

# Configuration
APP_NAME="{{_input_:app_name_}}"
ENVIRONMENT="${1:-staging}"
BUILD_DIR="./build"
DEPLOY_USER="{{_input_:deploy_user_}}"
DEPLOY_HOST="{{_input_:deploy_host_}}"
DEPLOY_PATH="/var/www/${APP_NAME}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

cleanup() {
    log_info "Cleaning up..."
    # Add cleanup commands here
}

trap cleanup EXIT

main() {
    log_info "Starting deployment of ${APP_NAME} to ${ENVIRONMENT}"

    # Pre-deployment checks
    if [[ ! -d "${BUILD_DIR}" ]]; then
        log_error "Build directory ${BUILD_DIR} does not exist"
        exit 1
    fi

    # Build application
    log_info "Building application..."
    {{_input_:build_command_}}

    # Run tests
    log_info "Running tests..."
    {{_input_:test_command_}}

    # Deploy
    log_info "Deploying to ${ENVIRONMENT}..."
    rsync -avz --delete \
        "${BUILD_DIR}/" \
        "${DEPLOY_USER}@${DEPLOY_HOST}:${DEPLOY_PATH}/"

    # Restart service
    log_info "Restarting service..."
    ssh "${DEPLOY_USER}@${DEPLOY_HOST}" \
        "sudo systemctl restart ${APP_NAME}"

    log_info "Deployment completed successfully!"
    {{_cursor_}}
}

main "$@"
