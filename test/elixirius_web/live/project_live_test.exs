defmodule ElixiriusWeb.ProjectLiveTest do
  use ElixiriusWeb.ConnCase

  import Phoenix.LiveViewTest
  import Elixirius.WorkshopFixtures

  defp create_project(conn) do
    project = project_fixture(%{user_id: conn.user.id})
    %{project: project}
  end

  describe "Index" do
    setup [:register_and_log_in_user, :create_project]

    test "lists all projects", %{conn: conn, project: project} do
      {:ok, index_live, html} = live(conn, Routes.project_index_path(conn, :index))

      assert html =~ "My Projects"
      assert html =~ project.name

      index_live |> element("a", project.name) |> render_click()
      assert_redirect(index_live, Routes.project_show_path(conn, :show, project.slug))
    end

    test "saves new project", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.project_index_path(conn, :index))

      assert index_live |> element("a", "New Project") |> render_click() =~ "New Project"

      assert_patch(index_live, Routes.project_index_path(conn, :new))

      assert index_live
             |> form("#form--new_project_form", project: invalid_project_attrs())
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#form--new_project_form", project: %{name: "My Project"})
        |> render_submit()
        |> follow_redirect(conn, Routes.project_index_path(conn, :index))

      assert html =~ "Project created successfully"
      assert html =~ "My Project"
    end
  end

  describe "Show" do
    setup [:register_and_log_in_user, :create_project]

    test "displays project", %{conn: conn, project: project} do
      {:ok, _show_live, html} = live(conn, Routes.project_show_path(conn, :show, project.slug))

      assert html =~ project.name
    end

    test "setup project", %{conn: conn, project: project} do
      {:ok, show_live, _html} = live(conn, Routes.project_show_path(conn, :setup, project.slug))

      assert show_live
             |> form("#form--project_form", project: %{name: nil})
             |> render_change() =~
               "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#form--project_form", project: %{name: "New Name"})
        |> render_submit()
        |> follow_redirect(conn, Routes.project_show_path(conn, :show, project.slug))

      assert html =~ "Project updated successfully"
      assert html =~ "New Name"
    end

    test "deletes project in listing", %{conn: conn, project: project} do
      {:ok, setup_live, _html} = live(conn, Routes.project_show_path(conn, :setup, project.slug))

      assert setup_live |> element("button", "Delete") |> render_click()
      assert_redirect(setup_live, Routes.project_index_path(conn, :index))
    end
  end
end
