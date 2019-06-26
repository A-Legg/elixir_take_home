defmodule Skynet.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/list" do
    send_resp(conn, 200, Skynet.list_terminators())
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
