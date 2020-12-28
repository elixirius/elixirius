defmodule Elixirius.Constructor.Supervisor do
  @moduledoc false

  use DynamicSupervisor

  alias Elixirius.Constructor.Worker

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def get_worker(child_name) do
    start_worker(child_name)
    |> case do
      {:ok, _pid} -> {:ok, Worker.info(child_name)}
      {:error, {:already_started, _pid}} -> {:ok, Worker.info(child_name)}
    end
  end

  def start_worker(child_name) do
    DynamicSupervisor.start_child(
      __MODULE__,
      %{id: Worker, start: {Worker, :start_link, [child_name]}, restart: :transient}
    )
  end
end
