defmodule Elixirius.WorkshopTest do
  use Elixirius.DataCase

  import Elixirius.WorkshopFixtures

  alias Elixirius.Workshop

  describe "projects" do
    alias Elixirius.Workshop.Project

    test "list_projects/0 returns all projects" do
      project = project_fixture()

      assert Workshop.list_projects(project.user_id) == [project]
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert Workshop.get_project!(project.user_id, project.slug) == project
    end

    test "create_project/1 with valid data creates a project" do
      attrs = valid_project_attrs()
      assert {:ok, %Project{} = project} = Workshop.create_project(attrs)
      assert project.name == attrs.name
      assert project.slug == attrs.slug
      assert project.user_id == attrs.user_id
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Workshop.create_project(invalid_project_attrs())
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()
      assert {:ok, %Project{} = project} = Workshop.update_project(project, %{name: "new name"})
      assert project.name == "new name"
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Workshop.update_project(project, %{name: nil})
      assert project == Workshop.get_project!(project.user_id, project.slug)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Workshop.delete_project(project)

      assert_raise Ecto.NoResultsError, fn ->
        Workshop.get_project!(project.user_id, project.slug)
      end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Workshop.change_project(project)
    end
  end
end
