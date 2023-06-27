defmodule WordsEtc.Repo do
  use Ecto.Repo,
    otp_app: :words_etc,
    adapter: Ecto.Adapters.SQLite3
end
