# Detect package manager
PKG_MANAGER := $(shell command -v apt 2>/dev/null && echo apt || echo brew)

# First time setup
setup:
	@if [ "$(PKG_MANAGER)" = "apt" ]; then \
		apt update && apt install -y uv podman-compose; \
	else \
		brew install uv podman-compose; \
	fi
	uv python install 3.14

	uv venv
	. .venv/bin/activate && uv sync

	mkdir -p local-files
	podman-compose up -d

# Run the application
run:
	podman-compose up -d
	. .venv/bin/activate && python main.py