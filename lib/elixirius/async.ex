defmodule Elixirius.Async do
  @moduledoc false

  def execute(fun) do
    Task.Supervisor.async_nolink(Elixirius.TaskSupervisor, fun)
  end
end
