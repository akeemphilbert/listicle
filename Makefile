# Listicle Mono-Repo Makefile
# Provides common commands for managing the pseudo mono-repo structure

.PHONY: help init update build test clean docker-up docker-down install-ui install-services

# Default target
help: ## Display available commands
	@echo "Available commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

init: ## Initialize all submodules and install dependencies
	@echo "Initializing submodules..."
	git submodule update --init --recursive
	@echo "Installing UI dependencies..."
	$(MAKE) install-ui
	@echo "Installing service dependencies..."
	$(MAKE) install-services

update: ## Update all submodules to latest
	@echo "Updating submodules..."
	git submodule update --remote --recursive

install-ui: ## Install dependencies for UI projects
	@echo "Installing UI dependencies..."
	@if [ -d "ui/listicle-extension" ] && [ -f "ui/listicle-extension/package.json" ]; then \
		cd ui/listicle-extension && npm install; \
	else \
		echo "No UI projects found or package.json missing"; \
	fi

install-services: ## Install dependencies for service projects
	@echo "Installing service dependencies..."
	@for dir in services/*/; do \
		if [ -d "$$dir" ] && [ -f "$$dir/go.mod" ]; then \
			echo "Installing Go dependencies for $$dir"; \
			cd "$$dir" && go mod tidy; \
		elif [ -d "$$dir" ] && [ -f "$$dir/package.json" ]; then \
			echo "Installing Node.js dependencies for $$dir"; \
			cd "$$dir" && npm install; \
		fi; \
	done

build: ## Build all projects
	@echo "Building all projects..."
	@echo "Building UI projects..."
	@if [ -d "ui/listicle-extension" ] && [ -f "ui/listicle-extension/package.json" ]; then \
		cd ui/listicle-extension && npm run build; \
	fi
	@echo "Building service projects..."
	@for dir in services/*/; do \
		if [ -d "$$dir" ] && [ -f "$$dir/go.mod" ]; then \
			echo "Building Go service in $$dir"; \
			cd "$$dir" && go build -o bin/ ./...; \
		elif [ -d "$$dir" ] && [ -f "$$dir/package.json" ]; then \
			echo "Building Node.js service in $$dir"; \
			cd "$$dir" && npm run build; \
		fi; \
	done

test: ## Run tests across all projects
	@echo "Running tests..."
	@echo "Testing UI projects..."
	@if [ -d "ui/listicle-extension" ] && [ -f "ui/listicle-extension/package.json" ]; then \
		cd ui/listicle-extension && npm test; \
	fi
	@echo "Testing service projects..."
	@for dir in services/*/; do \
		if [ -d "$$dir" ] && [ -f "$$dir/go.mod" ]; then \
			echo "Testing Go service in $$dir"; \
			cd "$$dir" && go test ./...; \
		elif [ -d "$$dir" ] && [ -f "$$dir/package.json" ]; then \
			echo "Testing Node.js service in $$dir"; \
			cd "$$dir" && npm test; \
		fi; \
	done

clean: ## Clean build artifacts
	@echo "Cleaning build artifacts..."
	@find . -name "node_modules" -type d -exec rm -rf {} + 2>/dev/null || true
	@find . -name "dist" -type d -exec rm -rf {} + 2>/dev/null || true
	@find . -name "build" -type d -exec rm -rf {} + 2>/dev/null || true
	@find . -name "bin" -type d -exec rm -rf {} + 2>/dev/null || true
	@find . -name "*.exe" -delete 2>/dev/null || true
	@find . -name "*.test" -delete 2>/dev/null || true
	@find . -name "*.out" -delete 2>/dev/null || true

docker-up: ## Start all services via docker-compose
	@echo "Starting services with Docker Compose..."
	docker-compose up -d

docker-down: ## Stop all services
	@echo "Stopping services..."
	docker-compose down

docker-logs: ## View logs from all services
	@echo "Viewing service logs..."
	docker-compose logs -f

# Development helpers
dev-ui: ## Start UI development server
	@if [ -d "ui/listicle-extension" ] && [ -f "ui/listicle-extension/package.json" ]; then \
		cd ui/listicle-extension && npm run dev; \
	else \
		echo "No UI project found or package.json missing"; \
	fi

dev-services: ## Start all service development servers
	@echo "Starting service development servers..."
	@for dir in services/*/; do \
		if [ -d "$$dir" ] && [ -f "$$dir/go.mod" ]; then \
			echo "Starting Go service in $$dir"; \
			cd "$$dir" && go run . & \
		elif [ -d "$$dir" ] && [ -f "$$dir/package.json" ]; then \
			echo "Starting Node.js service in $$dir"; \
			cd "$$dir" && npm run dev & \
		fi; \
	done

# Git submodule helpers
submodule-status: ## Show submodule status
	@echo "Submodule status:"
	git submodule status

submodule-sync: ## Sync submodule URLs
	@echo "Syncing submodule URLs..."
	git submodule sync --recursive

# Add new submodule helper
add-ui-submodule: ## Add a new UI submodule (usage: make add-ui-submodule URL=<git-url> NAME=<folder-name>)
	@if [ -z "$(URL)" ] || [ -z "$(NAME)" ]; then \
		echo "Usage: make add-ui-submodule URL=<git-url> NAME=<folder-name>"; \
		exit 1; \
	fi
	git submodule add $(URL) ui/$(NAME)

add-service-submodule: ## Add a new service submodule (usage: make add-service-submodule URL=<git-url> NAME=<folder-name>)
	@if [ -z "$(URL)" ] || [ -z "$(NAME)" ]; then \
		echo "Usage: make add-service-submodule URL=<git-url> NAME=<folder-name>"; \
		exit 1; \
	fi
	git submodule add $(URL) services/$(NAME)
