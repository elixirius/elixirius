defmodule ElixiriusWeb.ProjectLive.Index do
  @moduledoc false

  use ElixiriusWeb, :live_view

  alias Elixirius.Workshop
  alias Elixirius.Workshop.Project

  @impl true
  def mount(_params, %{"current_user" => user}, socket) do
    {
      :ok,
      socket
      |> assign(:current_user, user)
      |> assign(:projects, list_projects(user.id))
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Project")
    |> assign(:project, %Project{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "My Projects")
    |> assign(:project, nil)
  end

  defp list_projects(user_id) do
    Workshop.list_projects(user_id)
  end
end
