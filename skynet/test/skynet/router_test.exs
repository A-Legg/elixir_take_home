defmodule Skynet.RouterTest do
  use ExUnit.Case
  use Plug.Test

  @opts Skynet.Router.init([])

  describe "/list" do
    test "it returns a list of terminator pids" do
      {:ok, pid} = Skynet.spawn_terminator()

      conn =
        :get
        |> conn("/list")
        |> Skynet.Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 200
      assert String.contains?(conn.resp_body, inspect(pid))
      Supervisor.terminate_child(Skynet.Supervisor, pid)
    end
  end
end
