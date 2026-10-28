.PHONY: all up down clean restart logs ps

CYAN := \033[1;36m
GREEN := \033[1;32m
YELLOW := \033[1;33m
RESET := \033[0m

all: up

up:
	@printf '%b\n' '$(CYAN)[Inception]$(RESET) Preparing data directories...'
	@bash srcs/requirements/wordpress/tools/start-dir.sh
	@printf '%b\n' '$(CYAN)[Inception]$(RESET) Building and starting services...'
	@cd srcs && docker compose up -d --build
	@printf '%b\n' '$(GREEN)[Inception]$(RESET) Services are up.'

down:
	@printf '%b\n' '$(YELLOW)[Inception]$(RESET) Stopping services...'
	@cd srcs && docker compose down
	@printf '%b\n' '$(GREEN)[Inception]$(RESET) Services are stopped.'

clean:
	@printf '%b\n' '$(YELLOW)[Inception]$(RESET) Removing containers, network, and images (data is preserved)...'
	@cd srcs && docker compose down --rmi all
	@printf '%b\n' '$(GREEN)[Inception]$(RESET) Containers, network, and images are removed.'

restart: down up

logs:
	@printf '%b\n' '$(CYAN)[Inception]$(RESET) Following service logs (Ctrl+C to stop)...'
	@cd srcs && docker compose logs -f

ps:
	@printf '%b\n' '$(CYAN)[Inception]$(RESET) Service status:'
	@cd srcs && docker compose ps