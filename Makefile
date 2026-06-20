.PHONY: help lint test install

# Show available targets
help:
	@echo "claunch - available make targets:"
	@echo "  make lint     Run shellcheck on the shell scripts"
	@echo "  make test     Run the smoke tests"
	@echo "  make install  Install claunch to \$$HOME/bin"
	@echo "  make help     Show this help"

# Static analysis of all shell scripts
lint:
	shellcheck bin/claunch install.sh tests/test_claunch.sh

# Run the smoke test suite
test:
	bash tests/test_claunch.sh

# Install claunch locally
install:
	bash install.sh
