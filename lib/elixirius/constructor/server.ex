defmodule Elixirius.Constructor.Server do
  defstruct id: nil, logs: [], process: nil, url: nil, last_message_at: nil

  @default_port "7271"

  def new(id) do
    %__MODULE__{id: id}
  end

  def start(%__MODULE__{} = server) do
    path = Path.join([File.cwd!(), "projects", server.id])
    assets_path = Path.join([File.cwd!(), "projects", server.id, "assets"])

    mix_deps_get(path)
    npm_install(assets_path)

    new_server =
      server
      |> Map.merge(%{process: mix_phx_server(path), url: "http://localhost:#{@default_port}/"})

    {:ok, new_server}
  end

  def stop(%__MODULE__{} = server) do
    server_pid =
      Path.join([File.cwd!(), "projects", server.id, "server.pid"])
      |> File.read!()

    System.cmd("kill", ["-9", server_pid])

    new_server = Map.merge(server, %{process: nil, url: nil})

    {:ok, new_server}
  end

  @logs_limit 1000

  def log(%__MODULE__{} = server, message) do
    new_server =
      server
      |> Map.merge(%{
        logs: Enum.take([message | server.logs], @logs_limit),
        last_message_at: Time.utc_now()
      })

    {:ok, new_server}
  end

  defp mix_deps_get(path) do
    Porcelain.spawn_shell("mix deps.get",
      in: :receive,
      out: {:send, self()},
      dir: path
    )
  end

  defp npm_install(path) do
    Porcelain.spawn_shell("npm install",
      in: :receive,
      out: {:send, self()},
      dir: path
    )
  end

  defp mix_phx_server(path) do
    Porcelain.spawn_shell("mix phx.server",
      in: :receive,
      out: {:send, self()},
      dir: path,
      # TODO: Implement port pool
      env: [{"PORT", @default_port}]
    )
  end
end
