defmodule Elixirius.Constructor.App do
  @moduledoc false

  @derive Jason.Encoder
  @enforce_keys [:slug, :name, :workdir_path]

  defstruct slug: nil,
            name: nil,
            constructor_version: "",
            workdir_path: nil,
            deps: %{components: []}

  @projects "projects"
  @elixirius_dir ".elixirius"
  @app_filename "app.json"
  @path_delim "/"

  def new(slug, name, attrs \\ %{}) do
    app =
      %__MODULE__{
        slug: slug,
        name: name,
        workdir_path: "#{@projects}/#{slug}/#{@elixirius_dir}"
      }
      |> Map.merge(attrs)

    {:ok, app}
  end

  def init_dir(%__MODULE__{} = app) do
    (!File.exists?(app.workdir_path) && File.mkdir_p(app.workdir_path))
    |> case do
      :ok -> {:ok, app}
      false -> {:error, :already_exists}
      error -> error
    end
  end

  def save(%__MODULE__{} = app) do
    [app.workdir_path, @app_filename]
    |> Enum.join(@path_delim)
    |> File.write(Jason.encode!(app, pretty: true), [:binary])
    |> case do
      :ok -> {:ok, app}
      error -> error
    end
  end

  def read(project_slug) do
    with app_path <- build_app_path(project_slug),
         {:ok, file_data} <- File.read(app_path),
         {:ok, json} <- Jason.decode(file_data, keys: :atoms) do
      new(project_slug, json["name"], json)
    else
      {:error, :enoent} -> {:error, :not_exists}
      error -> error
    end
  end

  defp build_app_path(project_slug) do
    [@projects, project_slug, @elixirius_dir, @app_filename]
    |> Enum.join(@path_delim)
  end
end
