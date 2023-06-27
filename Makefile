.PHONY: help migrate-test migrate-dev test credo dialyzer run
DEFAULT_GOAL: help

## Run migrations on the test database
migrate-test:
	MIX_ENV=test mix ecto.migrate

## Run migrations on the development database
migrate-dev:
	MIX_ENV=dev mix ecto.migrate

## Run the test suite
test: migrate-test
	MIX_ENV=test mix test

## Run the linter
credo: migrate-test
	MIX_ENV=test mix credo

## Run static analysis
dialyzer: migrate-test
	MIX_ENV=test mix dialyzer

## Launch the development server
run: migrate-dev
	MIX_ENV=dev mix phx.server

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
