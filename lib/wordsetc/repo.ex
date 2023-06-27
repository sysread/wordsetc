defmodule Wordsetc.Repo do
  use Ecto.Repo,
    otp_app: :wordsetc,
    adapter: Ecto.Adapters.SQLite3
end
