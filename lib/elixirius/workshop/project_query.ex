defmodule Elixirius.Workshop.ProjectQuery do
  @moduledoc false

  import Ecto.Query, warn: false

  alias Elixirius.Workshop.Project

  def user_projects(user_id) do
    from(
      p in Project,
      where: p.user_id == ^user_id
    )
  end

  def user_project_by_slug(user_id, project_slug) do
    from(
      p in Project,
      where: p.user_id == ^user_id,
      where: p.slug == ^project_slug
    )
  end
end
