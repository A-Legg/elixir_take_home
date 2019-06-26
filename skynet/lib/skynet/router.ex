defmodule Skynet.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/list" do
    body = Jason.encode!(Skynet.list_terminators())

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, body)
  end

  post "/spawn" do
    case Skynet.spawn_terminator() do
      {:ok, pid} ->
        body = Jason.encode!(%{id: inspect(pid)})

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, body)

      _ ->
        send_resp(conn, 500, "Something went wrong.")
    end
  end

  delete "/terminate" do
    with {:ok, %{"id" => string_pid}} <- Map.fetch(conn, :params),
         {:ok, pid} <- Skynet.Utils.pid_from_string(string_pid),
         :ok <- Skynet.kill_terminator(pid) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, "Ok")
    else
      _ ->
        send_resp(conn, 500, "Something went wrong")
    end
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
