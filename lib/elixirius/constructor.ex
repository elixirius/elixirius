defmodule Elixirius.Constructor do
  @moduledoc """
  Init Elixirius app configuration within a new project and manage it:
    - initiate new projects
    - manage pages
    - manage page elements
    - etc
  """

  alias Elixirius.Constructor.{App, Page, Element, Repo}

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
  Initiate new app app for a given project slug and id.

  - Create app file in given project dir as `/projects/sample-app/.elixirius/app.json`
  - TODO: Create home page as `/projects/sample-app/.elixirius/pages/index.json`

  ## Examples
      iex> {:ok, app} = Constructor.init_app("sample-app", "SampleApp")
      iex> app
      %App{id: "SampleApp", slug: "sample-app", path: "projects/sample-app/.elixirius", ...}

  ## Errros
      # When the app already exists constructor tries to avoid a rewrite
      iex> {:error, :already_exists} = Constructor.init_app("sample-app")
  """
  def init_app(project_id, project_name) do
    attrs = %{constructor_version: current_version()}

    with {:ok, app} <- App.new(project_id, project_name, attrs),
         {:ok, app} <- Repo.init_store(app),
         {:ok, app} <- Repo.save(app),
         {:ok, _p} <- add_page(app, "index") do
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
      %App{id: "SampleApp", slug: "sample-app", path: "projects/sample-app/.elixirius", ...}


  ## Errros
      # When the app is not exists
      iex> {:error, :not_exists} = Constructor.get_app("missing-app")
  """
  def get_app(project_slug) do
    Repo.get_app(project_slug)
  end

  @doc """
  Create new page

  ## Examples
      iex> {:ok, app} = Constructor.get_app("sample-app")
      iex> {:ok, page} = Constructor.add_page(app, "index")
      iex> page
      %Page{project: "sample-app", id: "index"}


  ## Errros
      # Page is not unique
      iex> {:error, :already_exists} = Constructor.add_page(app, "existing_page")
  """
  def add_page(%App{} = app, page_id) do
    with {:ok, page} <- Page.new(app.id, page_id),
         {:ok, page} <- Repo.save(page) do
      {:ok, page}
    else
      error -> error
    end
  end

  @doc """
  Get page

  ## Examples
      iex> {:ok, app} = Constructor.get_page("sample-app")
      iex> {:ok, index_page} = Constructor.get_page(app)
      iex> {:ok, about_page} = Constructor.get_page(app, "about")
      iex> index_page
      %Page{project: "sample-app", id: "index"}
      iex> about_page
      %Page{project: "sample-app", id: "about_page"}


  ## Errros
      # Page not exists
      iex> {:error, :not_exists} = Constructor.get_page(app, "missing_page")
  """
  def get_page(%App{} = app, page_id \\ "index") do
    with {:ok, page} <- Repo.get_page(app, page_id) do
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
      iex> {:ok, page} = Constructor.add_element(page, "Header")
      iex> page
      %Page{project: "sample-app", id: "index", elements: %Element{type: "Header", id: "header_1"}}
  """
  def add_element(%Page{} = page, element_type, opts \\ %{}) do
    with {:ok, element_id} <- Page.generate_element_id(page, element_type),
         {:ok, element} <- Element.new(element_type, element_id, opts),
         {:ok, page} <- Page.add_element(page, element),
         {:ok, page} <- Repo.save(page) do
      {:ok, page}
    else
      error -> error
    end
  end

  @doc """
  Update an element on the page

  ## Examples
      iex> {:ok, page} = Constructor.update_element(page, "header_1", %{id: "top_header", parent: "...", position: 1})
      iex> page
      %Page{project: "sample-app", id: "index", elements: %Element{type: "Header", id: "top_header", parent: "...", position: 1}}

  ## Errros
    # Element does not exist
    iex> {:error, :not_exists} = Constructor.update_element(page, "header_2")
    # Give id is null
    iex> {:error, [{:error, :id, :presence, "must be present"}]} = Constructor.update_element(page, "header_2", %{id: nil})
    # Give id is not unique
    iex> {:error, [{:error, :id, :uniquness, "must be unique"}]} = Constructor.update_element(page, "header_2", %{id: "top_header"})
    # Given parent is not exists
    iex> {:error, [{:error, :parent, :exists,  "must exists"}] = Constructor.update_element(page, "header_2", %{parent: "none"})
  """
  def update_element(page, elem_id, opts \\ %{}) do
    with {:ok, elem} <- Page.get_element(page, elem_id),
         {:ok, opts} <- Element.validate(elem, opts),
         {:ok, page} <- Page.validate_element_id(page, opts[:id]),
         {:ok, page} <- Page.validate_element_parent(page, opts[:parent]),
         {:ok, page} <- Page.update_element(page, elem, opts),
         {:ok, page} <- Repo.save(page) do
      {:ok, page}
    else
      error -> error
    end
  end

  @doc """
  Remove an element on the page. Children also will be removed

  ## Examples
      iex> {:ok, page} = Constructor.remove_element(page, "header_1")
      iex> page
      %Page{project: "sample-app", id: "index", elements: []}

  ## Errros
    # Element does not exist
    iex> {:error, :not_exists} = Constructor.remove_element(page, "header_2")
  """
  def remove_element(page, elem_id) do
    with {:ok, elem} <- Page.get_element(page, elem_id),
         {:ok, page} <- Page.remove_element(page, elem),
         {:ok, page} <- Repo.save(page) do
      {:ok, page}
    else
      error -> error
    end
  end
end
