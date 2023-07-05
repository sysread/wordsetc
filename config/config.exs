# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :words_etc,
  ecto_repos: [WordsEtc.Repo]

# Configures the endpoint
config :words_etc, WordsEtcWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: WordsEtcWeb.ErrorHTML, json: WordsEtcWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: WordsEtc.PubSub,
  live_view: [signing_salt: "QvSUdrzR"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
