import Config

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
config :words_etc, WordsEtcWeb.Endpoint,
  http: [:inet6, port: 4000],
  url: [host: "wordsetc.tplinkdns.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/manifest.json",
  server: true,
  https: [
    :inet6,
    port: 4000,
    cipher_suite: :strong,
    certfile: "/etc/letsencrypt/live/wordsetc.tplinkdns.com/fullchain.pem",
    keyfile: "/etc/letsencrypt/live/wordsetc.tplinkdns.com/privkey.pem",
    transport_options: [socket_opts: [:reuseaddr, :inet6]]
  ]
