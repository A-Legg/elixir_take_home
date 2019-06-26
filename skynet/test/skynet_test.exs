defmodule SkynetTest do
  use ExUnit.Case, async: false

  describe "spawn_terminator/0" do
    test "it starts a terminator process under the supervision of the skynet supervisor" do
      {:ok, pid} = Skynet.spawn_terminator()

      [{_, supervised_pid, _, _}] = DynamicSupervisor.which_children(Skynet.Supervisor)

      assert pid === supervised_pid
      Supervisor.terminate_child(Skynet.Supervisor, pid)
    end
  end

  describe "kill_terminator/1" do
    test "it kills a terminator with a given pid" do
      {:ok, pid} = Skynet.Supervisor.start_child()

      Skynet.kill_terminator(pid)

      refute Process.alive?(pid)
    end
  end

  describe "list_terminators/0" do
    test "it lists all terminators" do
      {:ok, pid} = Skynet.Supervisor.start_child()

      assert [%{id: inspect(pid)}] === Skynet.list_terminators()
      Supervisor.terminate_child(Skynet.Supervisor, pid)
    end
  end
end
