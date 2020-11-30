defmodule Elixirius.Workshop.Project do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Elixirius.Accounts.User

  schema "projects" do
    field :name, :string
    field :slug, :string

    belongs_to(:user, User)

    timestamps()
  end

  @reserved_slugs ~w(new projects project join enter profile elixirium elixir ecto postgres)
  @slug_regex ~r/^[A-Za-z0-9-]+$/

  @doc false
  def create_changeset(project, attrs) do
    project
    |> cast(attrs, [:name, :slug, :user_id])
    |> generate_slug()
    |> validate_required([:name, :slug, :user_id])
    |> validate_exclusion(:slug, @reserved_slugs)
    |> validate_format(:slug, @slug_regex, message: "Only a-z, 0-9 and - characters are allowed")
    |> unique_constraint(:slug)
  end

  @doc false
  def update_changeset(project, attrs) do
    project
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  defp generate_slug(changeset) do
    if changeset.changes[:slug] do
      changeset
    else
      change(changeset, %{slug: SecureRandom.hex(3)})
    end
  end
end
