# Simple Docker cleanup for mini-rag project

.PHONY: help show clean safe-clean clean-old danger

help:
	@echo "Docker commands:"
	@echo "  make show       - Show what's in Docker"
	@echo "  make clean      - Clean unused stuff (safe)"
	@echo "  make clean-old  - Remove old images only"
	@echo "  make danger     - Delete everything (dangerous!)"

# Show what we have
show:
	@echo "=== Running containers ==="
	@docker ps
	@echo "=== All images ==="
	@docker images
	@echo "=== Disk usage ==="
	@docker system df

# Safe cleanup - only unused stuff
clean:
	@echo "Cleaning unused Docker stuff..."
	@docker image prune -a -f
	@docker container prune -f
	@echo "Done!"

# Remove old images only
clean-old:
	@echo "Removing unused images..."
	@docker image prune -a -f
	@echo "Old images removed!"

# Dangerous - everything goes
danger:
	@echo "WARNING: This deletes EVERYTHING!"
	@read -p "Type yes to continue: " answer && [ "$$answer" = "yes" ] || exit 1
	@docker stop $$(docker ps -aq) 2>/dev/null || true
	@docker system prune -a -f --volumes
	@echo "Everything deleted!"

mongo-up:
	@echo "Starting MongoDB with docker-compose..."
	@docker-compose -f docker/docker-compose.yml up -d
	@echo "MongoDB started! Check with 'docker ps'"
