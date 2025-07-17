.PHONY: all build help push run extract update-package-lock

HOST_UID ?= `id -u`
HOST_GID ?= `id -g`
DOCKER_IMAGE_NAME ?= ghcr.io/gocom/capture-website
DOCKER_IMAGE_TAG ?= dev
DOCKER_IMAGE_PLATFORM ?= linux/amd64
DOCKER_IMAGE_COMMAND ?= bash

all: help

build:
	docker build --platform "$(DOCKER_IMAGE_PLATFORM)" -t "$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)" .

push:
	docker build --platform "$(DOCKER_IMAGE_PLATFORM)" -t "$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)" . --push

run:
	docker run --cap-add=SYS_ADMIN --volume ./screenshots:/screenshots -it --rm "$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)" "$(DOCKER_IMAGE_COMMAND)"

test:
	rm -rf screenshots
	docker run --cap-add=SYS_ADMIN --volume ./screenshots:/screenshots -it --rm "$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)" capture-website https://example.com/ --output=/screenshots/image.png

update-package-lock:
	docker run --volume ./screenshots:/screenshots -it --rm "$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)" gosu app:app bash -c 'npm update && cp /app/package.json /screenshots/ && cp /app/package-lock.json /screenshots/'
	mv screenshots/package.json package.json
	mv screenshots/package-lock.json package-lock.json

help:
	@echo "Manage project"
	@echo ""
	@echo "Usage:"
	@echo "  $$ make [command] ["
	@echo "    [DOCKER_IMAGE_NAME=<image>]"
	@echo "    [DOCKER_IMAGE_TAG=<tag>]"
	@echo "    [DOCKER_IMAGE_PLATFORM=<platform>]"
	@echo "    [DOCKER_IMAGE_COMMAND=<command>]"
	@echo "  ]"
	@echo ""
	@echo "Commands:"
	@echo ""
	@echo "  $$ make build"
	@echo "  Build Docker image"
	@echo ""
	@echo "  $$ make help"
	@echo "  Print this message"
	@echo ""
	@echo "  $$ make push"
	@echo "  Build and push Docker image"
	@echo ""
	@echo "  $$ make run"
	@echo "  Run the built Docker image"
	@echo ""
	@echo "  $$ make test"
	@echo "  Run some test"
	@echo ""
	@echo "  $$ make update-package-lock"
	@echo "  Update package lock"
	@echo ""
