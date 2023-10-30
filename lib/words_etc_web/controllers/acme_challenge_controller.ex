defmodule WordsEtcWeb.AcmeChallengeController do
  use WordsEtcWeb, :controller

  def index(conn, %{"path" => path}) do
    dir = "/var/www/acme/.well-known/acme-challenge"
    file = Path.join([dir, path])

    if File.exists?(file) do
      send_file(conn, 200, file)
    else
      send_resp(conn, 404, "")
    end
  end
end
