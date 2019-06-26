defmodule Skynet.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: Skynet.Supervisor},
      Plug.Cowboy.child_spec(scheme: :http, plug: Skynet.Router, options: [port: 4001])
    ]

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
