.PHONY: help pr-description mr-description github gitlab \
        lint format check validate clean docs update-readme \
        install test health

# Default target
help:
	@echo "Neovim Configuration - Available Commands"
	@echo ""
	@echo "PR/MR Description:"
	@echo "  make pr-description    Generate GitHub PR description"
	@echo "  make mr-description    Generate GitLab MR description"
	@echo ""
	@echo "Code Quality:"
	@echo "  make lint              Run luacheck linter"
	@echo "  make format            Format Lua files with stylua"
	@echo "  make check             Run lint + format check (no write)"
	@echo "  make validate          Run full config validation"
	@echo ""
	@echo "Documentation:"
	@echo "  make docs              Generate plugin documentation"
	@echo "  make update-readme     Update README with plugin list"
	@echo ""
	@echo "Maintenance:"
	@echo "  make clean             Remove cache and generated files"
	@echo "  make health            Run Neovim health checks"
	@echo "  make test              Test Neovim startup"

#------------------------------------------------------------------------------
# PR/MR Description
#------------------------------------------------------------------------------

pr-description:
	@nvim --headless -c "lua print(require('utils.pr_description').generate_description())" -c "qa"

mr-description:
	@nvim --headless -c "lua print(require('utils.pr_description').generate_description({is_gitlab=true}))" -c "qa"

# Aliases for backwards compatibility
github: pr-description
gitlab: mr-description

#------------------------------------------------------------------------------
# Code Quality
#------------------------------------------------------------------------------

lint:
	@echo "Running luacheck..."
	@luacheck lua/ --config .luacheckrc

format:
	@echo "Formatting with stylua..."
	@stylua --config-path stylua.toml lua/

format-check:
	@stylua --config-path stylua.toml --check lua/

check: lint format-check
	@echo "All checks passed!"

validate:
	@./scripts/validate.sh

#------------------------------------------------------------------------------
# Documentation
#------------------------------------------------------------------------------

docs:
	@./scripts/generate-docs.sh

update-readme:
	@./scripts/update-readme.sh

#------------------------------------------------------------------------------
# Maintenance
#------------------------------------------------------------------------------

clean:
	@echo "Cleaning cache files..."
	@rm -rf .aider.tags.cache.v4/
	@rm -rf .elixir-tools/
	@rm -f lazy-lock.json.bak
	@echo "Done!"

health:
	@nvim --headless -c "checkhealth" -c "qa"

test:
	@echo "Testing Neovim startup..."
	@nvim --headless -c "lua print('Startup OK - ' .. #require('lazy').plugins() .. ' plugins loaded')" -c "qa"
