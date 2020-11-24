defmodule Elixirius.Constructor do
  @moduledoc """
  Init Elixirius app configuration within a new project and manage it

  ```elixir
  alias Elixirius.Constructor
  ```
  """

  alias Elixirius.Constructor.{App, Page}

  @doc """
  Returns current elixirius app version.

  Track last used elixirius version is important for further upgrades

  ## Examples
      iex> version = Constructor.current_version()
      "0.1.0-alpha"
  """
  def current_version do
    {:ok, char_version} = :application.get_key(:elixirius, :vsn)

    List.to_string(char_version)
  end

  @doc """
  Initiate new app app for a given project slug and name.

  - Create app file in given project dir as `/projects/sample-app/.elixirius/app.json`
  - TODO: Create home page as `/projects/sample-app/.elixirius/pages/index.json`

  ## Examples
      iex> {:ok, app} = Constructor.init_app("sample-app", "SampleApp")
      iex> app
      %App{name: "SampleApp", slug: "sample-app", path: "projects/sample-app/.elixirius", ...}

  ## Errros
      # When the app already exists constructor tries to avoid a rewrite
      iex> {:error, :already_exists} = Constructor.init_app("sample-app")
  """
  def init_app(project_slug, project_name) do
    attrs = %{name: project_name, constructor_version: current_version()}

    with {:ok, app} <- App.new(project_slug, attrs),
         {:ok, app} <- App.init_dir(app),
         {:ok, app} <- App.save(app) do
      {:ok, app}
    else
      error -> error
    end
  end

  @doc """
  Read app config

  ## Examples
      iex> {:ok, app} = Constructor.get_app("sample-app")
      iex> app
      %App{name: "SampleApp", slug: "sample-app", path: "projects/sample-app/.elixirius", ...}


  ## Errros
      # When the app is not exists
      iex> {:error, :not_exists} = Constructor.get_app("missing-app")
  """
  def get_app(project_slug) do
    App.read(project_slug)
  end

  @doc """
  Create new page

  ## Examples
      iex> {:ok, page} = Constructor.add_page("sample-app", "index")
      iex> page
      %Page{project: "sample-app", name: "index"}


  ## Errros
      # When the app is not exists
      iex> {:error, :not_exists} = Constructor.add_page("missing-app", "index")

      # When the page is not unique
      iex> {:error, :already_exists} = Constructor.add_page("sample-app", "existing_page")
  """
  def add_page(project_slug, page_name) do
    with {:ok, page} <- Page.new(project_slug, page_name),
         {:ok, page} <- Page.save(page) do
      {:ok, page}
    else
      error -> error
    end
  end

  # TODO
  # def add_page_elem(project_slug, page_name, elem_name, opts \\ []) do
  # end

  # TODO
  # def update_page_elem(project_slug, page_name, elem_name, opts \\ []) do
  # end

  # TODO
  # def remove_page_elem(project_slug, page_name, elem_name, opts \\ []) do
  # end
end
