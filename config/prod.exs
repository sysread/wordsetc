import Config

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
config :words_etc, WordsEtcWeb.Endpoint,
  url: [host: "wordsetc.tplinkdns.com", scheme: "https", port: 443],
  http: [:inet6, port: 4000],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  server: true,
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE")
