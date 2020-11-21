defmodule Elixirius.Constructor do
  @moduledoc """
  Init Elixirius app appuration within a new project and manage it
  """

  alias Elixirius.Constructor.App

  @doc """
  Returns current elixirius app version

   ## Examples
      iex> version = Constructor.current_version()
      "0.1.0-alpha"
  """
  def current_version do
    {:ok, char_version} = :application.get_key(:elixirius, :vsn)

    List.to_string(char_version)
  end

  @doc """
  Initiates new app app for a given project slug and name

  ## Examples
      iex> {:ok, app} = Constructor.init("sample-app", "SampleApp")
      iex> app
      %App{name: "SampleApp", slug: "sample-app", path: "projects/sample-app/.elixirius", ...}

  """
  def init_app(project_slug, project_name) do
    app =
      %{
        slug: project_slug,
        name: project_name,
        constructor_version: current_version()
      }
      |> App.new()
      |> App.build_path()
      |> App.init_dir()
      |> App.save_config()

    {:ok, app}
  end

  def get_app(project_slug) do
    App.read_config(project_slug)
  end

  # def update_app(project_slug, key, value) do
  # end

  # def list_pages(project_slug) do
  # end

  # def add_page(project_slug, name, opts \\ []) do
  # end

  # def update_page(project_slug, name, opts \\ []) do
  # end

  # def remove_page(project_slug, name, opts \\ []) do
  # end

  # def add_page_elem(project_slug, page_name, elem_name, opts \\ []) do
  # end

  # def update_page_elem(project_slug, page_name, elem_name, opts \\ []) do
  # end

  # def remove_page_elem(project_slug, page_name, elem_name, opts \\ []) do
  # end
end
