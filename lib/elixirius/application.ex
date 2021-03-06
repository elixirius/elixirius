defmodule Elixirius.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @registry :constructor_registry

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Elixirius.Repo,
      # Start the Telemetry supervisor
      ElixiriusWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Elixirius.PubSub},
      # Start the Endpoint (http/https)
      ElixiriusWeb.Endpoint,
      # Task supervisor for Async module
      {Task.Supervisor, name: Elixirius.TaskSupervisor},
      {Elixirius.Constructor.Supervisor, []},
      {Registry, [keys: :unique, name: @registry]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Elixirius.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ElixiriusWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
