defmodule Elixirius.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string, null: false
      add :slug, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create(unique_index(:projects, [:slug]))
    create(index(:projects, [:user_id]))
  end
end
