.PHONY: help build up down logs status clean setup restart backup

help: ## Show this help message
	@echo "Abiotic Factor Server - Available Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""

build: ## Build the Docker image
	docker-compose build

up: ## Start the server in the background
	docker-compose up -d

down: ## Stop the server
	docker-compose down

logs: ## Show server logs (follow mode)
	docker-compose logs -f

status: ## Show server status
	docker-compose ps

clean: ## Stop server and remove volumes (WARNING: This deletes save data!)
	docker-compose down -v
	docker system prune -f

setup: build up ## Build and start the server
	@echo "Server starting... Check logs with 'make logs'"
	@echo "Game files will be downloaded on first run (this may take 5-10 minutes)"

restart: down up ## Restart the server

backup: ## Backup save data
	@mkdir -p backups
	@tar -czf backups/abfactor-backup-$(shell date +%Y%m%d-%H%M%S).tar.gz data/
	@echo "Backup created in backups/ directory"

# Default target
.DEFAULT_GOAL := help
