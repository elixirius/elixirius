defmodule Elixirius.Constructor do
  @moduledoc """
  Init Elixirius app configuration within a new project and manage it:
    - initiate new projects
    - manage pages
    - manage page elements
    - etc
  """

  alias Elixirius.Constructor.{App, Page, Element}

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
    attrs = %{constructor_version: current_version()}

    with {:ok, app} <- App.new(project_slug, project_name, attrs),
         {:ok, app} <- App.init_dir(app),
         {:ok, app} <- App.save(app),
         {:ok, _page} <- add_page(app, "index") do
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
      iex> {:ok, app} = Constructor.get_app("sample-app")
      iex> {:ok, page} = Constructor.add_page(app, "index")
      iex> page
      %Page{project: "sample-app", name: "index"}


  ## Errros
      # Page is not unique
      iex> {:error, :already_exists} = Constructor.add_page(app, "existing_page")
  """
  def add_page(%App{} = app, page_name) do
    with {:ok, page} <- Page.new(app.slug, page_name),
         {:ok, page} <- Page.save(page) do
      {:ok, page}
    else
      error -> error
    end
  end

  @doc """
  Add an element to the page

  ## Examples
      iex> {:ok, app} = Constructor.get_app("sample-app")
      iex> {:ok, page} = Constructor.get_page(app, "index")
      iex> {:ok, page} = Constructor.add_element(page, "")
      iex> page
      %Page{project: "sample-app", name: "index", elements: %Element{type: "Header", name: "header_1"}}
  """
  def add_element(%Page{} = page, element_type, opts \\ %{}) do
    with {:ok, element} <- Element.new(element_type, "header_1"),
         {:ok, page} <- Page.add_element(page, element),
         {:ok, page} <- Page.save(page) do
      {:ok, page}
    else
      error -> error
    end
  end

  # TODO
  # def update_element(page, elem_name, opts \\ []) do
  # end

  # TODO
  # def remove_element(page, elem_name, opts \\ []) do
  # end

  # TODO
  # def get_element(page, page_name) do
  # end

  # TODO
  # def generate_unique_element_name(page, element_type) do
  # end
end
