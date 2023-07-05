.PHONY: help mix_env build run daemon shell
DEFAULT_GOAL: default

default: build run

## Builds the docker image
build: mix_env
	docker build -t words_etc .

## Runs the docker image
run: mix_env
	docker run -p 4000:4000 --env-file .env -it words_etc

## Runs the docker image in daemon mode
daemon: mix_env
	docker run -p 4000:4000 --env-file .env -d words_etc

## Opens a shell in the docker image
shell: mix_env
	docker run -p 4000:4000 --env-file .env -it --entrypoint /bin/sh words_etc

## Runs the application locally
local:
	MIX_ENV=dev mix phx.server

## Displays the current mix environment
mix_env:
	@echo "MIX_ENV: $(MIX_ENV)"

# ------------------------------------------------------------------------------
# Displays the help menu, including any targets preceeded by a comment
# beginning with two hashes (##).
# ------------------------------------------------------------------------------
help:
	@echo "usage: make [target]\n"
	@awk '/^[a-zA-Z\-_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "    %-30s %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)