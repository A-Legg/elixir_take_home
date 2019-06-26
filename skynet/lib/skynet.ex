defmodule Skynet do
  def spawn_terminator do
    Skynet.Supervisor.start_child()
  end

  def kill_terminator(pid) do
    Supervisor.terminate_child(Skynet.Supervisor, pid)
  end

  def list_terminators do
    Skynet.Supervisor
    |> DynamicSupervisor.which_children()
    |> Enum.map(&elem(&1, 1))
    |> Enum.map(&format_pid/1)
  end

  defp format_pid(pid) do
    %{id: inspect(pid)}
  end
end
