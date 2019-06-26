defmodule Skynet.Utils do
  def pid_from_string("#PID" <> string) do
    pid =
      string
      |> :erlang.binary_to_list()
      |> :erlang.list_to_pid()

    {:ok, pid}
  end

  def pid_from_string(_) do
    {:error, :unable_to_convert}
  end
end
