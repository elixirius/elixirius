defmodule Elixirius.Constructor.Repo do
  @root_dir "projects"
  @elixirius_dir ".elixirius"
  @app_filename "app.json"
  @path_delim "/"
  @pages_dir "pages"

  alias Elixirius.Constructor.{App, Page}

  def init_store(%App{} = app) do
    workdir = build_workdir_path(app.slug)

    (!File.exists?(workdir) && File.mkdir_p(workdir))
    |> case do
      :ok -> {:ok, app}
      false -> {:error, :already_exists}
      error -> error
    end
  end

  def save(%App{} = app) do
    [build_workdir_path(app.slug), @app_filename]
    |> Enum.join(@path_delim)
    |> File.write(Jason.encode!(app, pretty: true), [:binary])
    |> case do
      :ok -> {:ok, app}
      error -> error
    end
  end

   def save(%Page{} = page) do
    page
    |> build_page_path()
    |> init_page_dir()
    |> File.write(Jason.encode!(page, pretty: true), [:binary])
    |> case do
      :ok -> {:ok, page}
      error -> error
    end
  end

  defp init_page_dir(page_path) do
    page_path
    |> Path.dirname()
    |> File.mkdir_p!()

    page_path
  end

  def get_app(project_slug) do
    with app_path <- build_app_path(project_slug),
         {:ok, file_data} <- File.read(app_path),
         {:ok, json} <- Jason.decode(file_data, keys: :atoms) do
      App.new(project_slug, json["name"], json)
    else
      {:error, :enoent} -> {:error, :not_exists}
      error -> error
    end
  end

  defp build_workdir_path(slug) do
    [@root_dir, slug, @elixirius_dir]
    |> Enum.join(@path_delim)
  end

  defp build_app_path(project_slug) do
    [@root_dir, project_slug, @elixirius_dir, @app_filename]
    |> Enum.join(@path_delim)
  end

  defp build_page_path(page) do
    [@root_dir, page.project, @elixirius_dir, @pages_dir, "#{page.name}.json"]
    |> Enum.join(@path_delim)
  end
end
