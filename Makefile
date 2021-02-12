COMPOSE_PROJECT_NAME := $(shell basename $(shell pwd))
COMPOSE_COMMAND := docker-compose


dev:
	docker-compose up -d
	@$(MAKE) --no-print-directory envs
	@echo
	@echo "Storage containers are up"
	@echo 'Run `make overmind` to start development servers'
.PHONY: dev

down:
	docker-compose down
	@$(MAKE) --no-print-directory envs
.PHONY: down

overmind:
	overmind start
.PHONY: overmind

envs: DB_PORT := $(shell docker-compose port db 5432 | cut -d ':' -f 2)
envs:
	@mkdir -p .direnv/envs
	@echo "${DB_PORT}" > .direnv/envs/DB_PORT 
.PHONY: envs
