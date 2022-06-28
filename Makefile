.PHONY: help

help: ## ❓ Show this help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

setup: ## 🔨 Create the "nginx-proxy" network
	docker network create -d bridge nginx-proxy || true
	docker volume create certs || true

build: ## 🔧 Pull & Build the docker images
	docker-compose pull --quiet || true
	docker-compose build --quiet

dev: ## 🛠️  Start containers (local development)
	docker-compose up --force-recreate --build

start: ## 🏭 Start containers (production)
    docker-compose cp vhost.d/. proxy:/etc/nginx/vhost.d
    docker-compose cp htpasswd/. proxy:/etc/nginx/htpasswd
	docker-compose up -d --force-recreate --remove-orphans

restart: ## 🔄 Restart containers
	docker-compose restart

stop: ## 🛑 Stop containers
	docker-compose stop

logs: ## 👀 Print logs (last 1000 lines)
	docker-compose logs --tail 1000
