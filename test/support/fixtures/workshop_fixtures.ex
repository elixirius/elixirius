defmodule Elixirius.WorkshopFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Elixirius.Workshop` context.
  """

  import Elixirius.AccountsFixtures

  alias Elixirius.Workshop

  def unique_project_slug, do: SecureRandom.hex(4)

  def invalid_project_attrs() do
    %{name: nil, slug: nil}
  end

  defp base_valid_project_attrs do
    %{
      name: "Project #{System.unique_integer()}",
      slug: unique_project_slug()
    }
  end

  def valid_project_attrs() do
    base_valid_project_attrs()
    |> Enum.into(%{user_id: user_fixture().id})
  end

  def valid_project_attrs(nil) do
    base_valid_project_attrs()
    |> Enum.into(%{user_id: user_fixture().id})
  end

  def valid_project_attrs(user_id) do
    base_valid_project_attrs()
    |> Enum.into(%{user_id: user_id})
  end

  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(valid_project_attrs(attrs[:user_id]))
      |> Workshop.create_project()

    project
  end
end
