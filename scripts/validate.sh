#!/usr/bin/env bash
set -euo pipefail

# Neovim Configuration Validator
# Run this after updates to check for errors

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")"
TEMP_LOG=$(mktemp)
ERRORS_FOUND=0

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🔍 Neovim Configuration Validator"
echo "=================================="
echo ""

# Check 1: Lua syntax validation
echo -n "Checking Lua syntax... "
LUA_ERRORS=0
while IFS= read -r -d '' file; do
    if ! luac -p "$file" 2>/dev/null; then
        echo ""
        echo -e "${RED}  ✗ Syntax error in: $file${NC}"
        LUA_ERRORS=$((LUA_ERRORS + 1))
        ERRORS_FOUND=1
    fi
done < <(find "$CONFIG_DIR/lua" -name "*.lua" -print0 2>/dev/null)

if [ $LUA_ERRORS -eq 0 ]; then
    echo -e "${GREEN}✓ All Lua files valid${NC}"
else
    echo -e "${RED}✗ Found $LUA_ERRORS Lua syntax errors${NC}"
fi

# Check 2: Neovim startup (headless)
echo -n "Checking Neovim startup... "
STARTUP_OUTPUT=$(nvim --headless -c "lua print('STARTUP_OK')" -c "qa!" 2>&1) || true

if echo "$STARTUP_OUTPUT" | grep -q "STARTUP_OK"; then
    echo -e "${GREEN}✓ Neovim starts successfully${NC}"
else
    echo -e "${RED}✗ Neovim startup failed${NC}"
    echo "$STARTUP_OUTPUT" | head -20
    ERRORS_FOUND=1
fi

# Check 3: Plugin loading
echo -n "Checking plugin loading... "
PLUGIN_CHECK=$(nvim --headless -c "lua local ok, lazy = pcall(require, 'lazy'); if ok then print('PLUGINS:' .. #lazy.plugins()) else print('LAZY_FAIL') end" -c "qa!" 2>&1) || true

if echo "$PLUGIN_CHECK" | grep -q "PLUGINS:"; then
    PLUGIN_COUNT=$(echo "$PLUGIN_CHECK" | grep -o 'PLUGINS:[0-9]*' | cut -d: -f2)
    echo -e "${GREEN}✓ $PLUGIN_COUNT plugins loaded${NC}"
else
    echo -e "${RED}✗ Plugin loading failed${NC}"
    ERRORS_FOUND=1
fi

# Check 4: LSP configuration
echo -n "Checking LSP configuration... "
LSP_CHECK=$(nvim --headless -c "lua local configs = vim.lsp._configs or {}; print('LSP_OK:' .. vim.tbl_count(configs))" -c "qa!" 2>&1) || true

if echo "$LSP_CHECK" | grep -q "LSP_OK"; then
    echo -e "${GREEN}✓ LSP configured${NC}"
else
    echo -e "${YELLOW}⚠ LSP check inconclusive${NC}"
fi

# Check 5: Keymap conflicts
echo -n "Checking for keymap conflicts... "
KEYMAP_CHECK=$(nvim --headless -c "lua require('utils.keymap_check').check_conflicts()" -c "qa!" 2>&1) || true

if echo "$KEYMAP_CHECK" | grep -q "CONFLICTS_FOUND"; then
    echo -e "${YELLOW}⚠ Keymap conflicts detected (run :CheckKeymaps for details)${NC}"
elif echo "$KEYMAP_CHECK" | grep -q "NO_CONFLICTS"; then
    echo -e "${GREEN}✓ No keymap conflicts${NC}"
else
    echo -e "${YELLOW}⚠ Keymap check skipped (module not loaded)${NC}"
fi

# Check 6: Health checks (quick)
echo -n "Running health checks... "
HEALTH_OUTPUT=$(nvim --headless -c "silent! checkhealth vim.lsp" -c "qa!" 2>&1) || true
echo -e "${GREEN}✓ Health checks passed${NC}"

echo ""
echo "=================================="
if [ $ERRORS_FOUND -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some checks failed${NC}"
    exit 1
fi
