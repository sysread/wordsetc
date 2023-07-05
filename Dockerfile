# We are going to use a multi-stage build process.
# First we define our build stage.
FROM elixir:1.15.0 AS build

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Set the workdir inside the container
WORKDIR /app

# Set the environment to production
ENV MIX_ENV=prod

# Copy the dependency definition files into the container
COPY mix.exs mix.lock ./

# Install all production dependencies.
RUN mix deps.get --only prod

# Compile all dependencies.
RUN mix deps.compile

# Copy all application files into the container.
COPY . .

# Compile the entire project.
RUN mix compile

# Digest the static files.
RUN mix phx.digest

# Now we create our release
RUN mix release

# We are going to use a new stage for the runtime environment.
FROM erlang:26-alpine

# Install sqlite
RUN apk add --no-cache sqlite

# We set the workdir and copy our release from the previous stage.
WORKDIR /app
COPY --from=build /app/_build/prod/rel/* ./

# Expose the port for Phoenix
EXPOSE 4000

# Set the entrypoint to our application start command
CMD ["bin/wordsetc", "start"]
