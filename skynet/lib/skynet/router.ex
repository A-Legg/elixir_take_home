defmodule Skynet.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/list" do
    send_resp(conn, 200, Skynet.list_terminators())
  end

  post "/spawn" do
    case Skynet.spawn_terminator() do
      {:ok, pid} ->
        send_resp(conn, 200, inspect(pid))

      _ ->
        send_resp(conn, 500, "Something went wrong.")
    end
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
