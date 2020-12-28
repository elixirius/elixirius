defmodule Elixirius.Constructor.Worker do
  @moduledoc false

  use GenServer
  require Logger
  alias Porcelain.Result
  alias Elixirius.Constructor.Server

  @registry :constructor_registry

  # API
  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: via_tuple(name))
  end

  def info(name), do: GenServer.call(via_tuple(name), :info)

  def start_server(name), do: GenServer.cast(via_tuple(name), :start_server)

  def stop_server(name), do: GenServer.cast(via_tuple(name), :stop_server)

  # Callbacks
  def init(name) do
    {:ok, %Server{id: name}}
  end

  def handle_call(:info, _from, server) do
    {:reply, server, server}
  end

  def handle_cast(:start_server, server) do
    {:ok, server} = Server.start(server)

    {:noreply, server}
  end

  def handle_cast(:stop_server, server) do
    {:ok, server} = Server.stop(server)

    {:noreply, server}
  end

  def handle_info({_pid, :data, :out, msg}, server) do
    {:ok, server} = Server.log(server, msg)

    {:noreply, server}
  end

  def handle_info({_pid, :result, %Result{status: status}}, server) do
    {:ok, server} = Server.log(server, "#{status}")

    {:noreply, server}
  end

  def terminate(reason, server) do
    Logger.info("Exiting worker: #{server.id} with reason: #{inspect(reason)}")
  end

  ## Private
  defp via_tuple(name), do: {:via, Registry, {@registry, name}}
end
