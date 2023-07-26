defmodule WordsEtcWeb.AcmeChallengeController do
  use WordsEtcWeb, :controller

  def index(conn, %{"path" => path}) do
    file = Path.join(["/var/www/acme", path])

    if File.exists?(file) do
      send_file(conn, 200, file)
    else
      send_resp(conn, 404, "")
    end
  end
end
