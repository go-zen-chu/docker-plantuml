IMAGE_NAME := plantuml-cli
GIT_HASH := $(shell git rev-parse --short HEAD)
IMAGE_FULL_NAME := $(IMAGE_NAME):$(GIT_HASH)

.PHONY: help
## print all available commands
help:
	@./make/help.sh

.PHONY: build
## build docker image
build:
	docker build -t $(IMAGE_FULL_NAME) .

.PHONY: update
## update packages of docker image
update:
	@./make/update.sh

.PHONY: commit-push
commit-push:
	@./make/commit-push.sh