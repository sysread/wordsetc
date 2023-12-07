defmodule WordsEtcWeb.Plugs.RequestLogger do
  import Plug.Conn
  require Logger

  def init(opts), do: opts

  def call(conn, _opts) do
    Logger.info("Request received: #{inspect(conn.request_path)}")

    {:ok, body, conn} = read_body(conn)
    Logger.info("Request body: #{body}")

    # Important: Reassign the read body if you need to use it down the pipeline
    put_private(conn, :raw_body, body)

    conn
  end
end
