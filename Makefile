# Makefile for mini-rag project
# Docker cleanup and management commands

.PHONY: help clean-docker stop-containers remove-containers remove-images clean-all docker-status

# Default target
help:
	@echo "Available commands for mini-rag project:"
	@echo "  make docker-status    - Show Docker status"
	@echo "  make stop-containers  - Stop all running containers"
	@echo "  make remove-containers- Remove all containers"
	@echo "  make remove-images    - Remove all Docker images"
	@echo "  make clean-docker     - Complete Docker cleanup"
	@echo "  make clean-all        - Nuclear option - clean everything"

# Show current Docker status
docker-status:
	@echo "=== Docker Status ==="
	@echo "Running containers:"
	@docker ps
	@echo "\nAll containers:"
	@docker ps -a
	@echo "\nDocker images:"
	@docker images

# Stop all containers
stop-containers:
	@echo "Stopping all Docker containers..."
	@docker stop $$(docker ps -aq) 2>/dev/null || echo "No containers to stop"

# Remove all containers
remove-containers: stop-containers
	@echo "Removing all Docker containers..."
	@docker rm $$(docker ps -aq) 2>/dev/null || echo "No containers to remove"

# Remove all images
remove-images:
	@echo "Removing all Docker images..."
	@docker rmi $$(docker images -q) 2>/dev/null || echo "No images to remove"

# Clean Docker (safe version)
clean-docker:
	@echo "Starting Docker cleanup..."
	@$(MAKE) stop-containers
	@docker system prune -f
	@docker volume prune -f
	@docker network prune -f
	@docker builder prune -f
	@echo "Docker cleanup completed!"

# Nuclear option - clean everything
clean-all:
	@echo "⚠️  WARNING: This will remove EVERYTHING from Docker!"
	@read -p "Are you sure? (y/N): " confirm && [ "$$confirm" = "y" ] || exit 1
	@$(MAKE) stop-containers
	@$(MAKE) remove-containers
	@$(MAKE) remove-images
	@docker system prune -a -f --volumes
	@docker builder prune -a -f
	@echo "🧹 Complete Docker cleanup finished!"

# Project specific commands (you can add your mini-rag commands here)
build:
	@echo "Building mini-rag project..."
	# Add your build commands here

run:
	@echo "Running mini-rag project..."
	# Add your run commands here

dev:
	@echo "Starting mini-rag in development mode..."
	# Add your dev commands here