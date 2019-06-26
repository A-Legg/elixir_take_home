defmodule Skynet.Terminator do
  use GenServer

  @five_seconds_in_milliseconds 5000
  @ten_seconds_in_milliseconds 10_000

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, [])
  end

  def init(_) do
    spawn_timer = Process.send_after(self(), :maybe_spawn, @five_seconds_in_milliseconds)
    die_timer = Process.send_after(self(), :maybe_die, @ten_seconds_in_milliseconds)
    {:ok, %{spawn_timer: spawn_timer, die_timer: die_timer}}
  end

  def handle_info(:maybe_spawn, state) do
    if terminator_should_spawn?(), do: Skynet.Supervisor.start_child()

    spawn_timer = Process.send_after(self(), :maybe_spawn, @five_seconds_in_milliseconds)
    {:noreply, %{state | spawn_timer: spawn_timer}}
  end

  def handle_info(:maybe_die, state) do
    if sarah_connor_kills?() do
      Supervisor.terminate_child(Skynet.Supervisor, self())
    else
      die_timer = Process.send_after(self(), :maybe_die, @ten_seconds_in_milliseconds)
      {:noreply, %{state | die_timer: die_timer}}
    end
  end

  defp sarah_connor_kills? do
    Enum.random(1..4) === 1
  end

  defp terminator_should_spawn? do
    Enum.random(1..5) === 1
  end
end
