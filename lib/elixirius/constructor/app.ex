defmodule Elixirius.Constructor.App do
  @moduledoc false

  defstruct slug: nil, name: nil, constructor_version: "", path: nil, deps: %{components: []}

  @projects "projects"
  @elixirius_dir ".elixirius"
  @app_filename "app.json"
  @path_delim "/"

  def new(attrs \\ %{}) do
    Map.merge(%__MODULE__{}, attrs)
  end

  def build_path(%__MODULE__{} = app) do
    Map.put(app, :path, "#{@projects}/#{app.slug}/#{@elixirius_dir}")
  end

  def init_dir(%__MODULE__{} = app) do
    File.mkdir_p!(app.path)

    app
  end

  def save_config(%__MODULE__{} = app) do
    [app.path, @app_filename]
    |> Enum.join(@path_delim)
    |> File.write!(to_json(app), [:binary])

    app
  end

  defp to_json(app), do: Jason.encode!(Map.from_struct(app), pretty: true)
  defp from_json(json), do: Jason.decode!(json, keys: :atoms) |> new()

  def read_config(project_slug) do
    [@projects, project_slug, @elixirius_dir, @app_filename]
    |> Enum.join(@path_delim)
    |> File.read()
    |> case do
      {:ok, json} -> {:ok, from_json(json)}
      {:error, :enoent} -> {:error, :missing_project}
      error -> error
    end
  end
end
