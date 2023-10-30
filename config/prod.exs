import Config

config :logger,
  backends: [:console, {LoggerFileBackend, :file}]

config :logger, :file,
  path: "/var/log/wordsetc.log",
  level: :info
