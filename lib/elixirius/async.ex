defmodule Elixirius.Async do
  def execute(fun) do
    Task.Supervisor.async_nolink(Elixirius.TaskSupervisor, fun)
  end
end
