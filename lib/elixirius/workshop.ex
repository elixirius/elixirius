defmodule Elixirius.Workshop do
  @moduledoc """
  The Workshop context.
  """
  alias Elixirius.Repo
  alias Elixirius.Workshop.{Project, ProjectQuery}

  @doc """
  Returns the list of user related projects.

  ## Examples
      iex> user = Accounts.get_user_by_email("user@exampple.com")
      iex> list_projects(user.id)
      [%Project{}, ...]

  """
  def list_projects(user_id) do
    user_id
    |> ProjectQuery.user_projects()
    |> Repo.all()
  end

  @doc """
  Gets a single user project by slug

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> user = Accounts.get_user_by_email("user@exampple.com")

      iex> get_project!(user.id, "a1b1")
      %Project{}

      iex> get_project!(user.id, "a2b2")
      ** (Ecto.NoResultsError)

  """
  def get_project!(user_id, project_slug) do
    user_id
    |> ProjectQuery.user_project_by_slug(project_slug)
    |> Repo.one!()
  end

  @doc """
  Creates a project.

  ## Examples

      iex> user = Accounts.get_user_by_email("user@exampple.com")

      iex> create_project(%{name: "New Project", slug: "new-project", user_id: user.id})
      {:ok, %Project{}}

      iex> create_project(%{name: nil, slug: nil, user_id: nil})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(attrs \\ %{}) do
    %Project{}
    |> Project.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{name: "New Name"})
      {:ok, %Project{}}

      iex> update_project(project, %{name: nil})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(%Project{} = project, attrs) do
    project
    |> Project.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

  """
  def delete_project(%Project{} = project) do
    Repo.delete(project)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_project(project)
      %Ecto.Changeset{data: %Project{}}

  """
  def change_project(%Project{} = project, attrs \\ %{}) do
    Project.create_changeset(project, attrs)
  end
end
