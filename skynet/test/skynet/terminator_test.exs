defmodule Skynet.TerminatorTest do
  use ExUnit.Case

  describe "spawning" do
    test "it sets a timer to maybe spawn every 5 seconds when initialized" do
      {:ok, pid} = Skynet.Supervisor.start_child()

      %{spawn_timer: spawn_timer} = :sys.get_state(pid)
      time = Process.read_timer(spawn_timer)

      assert_in_delta(time, 5000, 5)
    end

    test "it handles the maybe spawn message and resets the timer" do
      {:ok, pid} = Skynet.Supervisor.start_child()

      %{spawn_timer: old_timer} = :sys.get_state(pid)

      send(pid, :maybe_spawn)

      %{spawn_timer: spawn_timer} = :sys.get_state(pid)

      time = Process.read_timer(spawn_timer)

      refute old_timer === spawn_timer
      assert_in_delta(time, 5000, 5)
    end
  end

  describe "terminating" do
    test "it sets a timer to maybe terminate every 10 seconds when initialized" do
      {:ok, pid} = Skynet.Supervisor.start_child()

      %{die_timer: die_timer} = :sys.get_state(pid)
      time = Process.read_timer(die_timer)

      assert_in_delta(time, 10_000, 10)
    end
  end
end
