defmodule ElixiriusWeb.ProjectLive.Show do
  @moduledoc false

  use ElixiriusWeb, :live_view

  alias Elixirius.Workshop

  @impl true
  def mount(_params, %{"current_user" => user}, socket) do
    {:ok, assign(socket, :current_user, user)}
  end

  @impl true
  def handle_params(%{"project_slug" => project_slug}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:project, Workshop.get_project!(socket.assigns.current_user.id, project_slug))}
  end

  defp page_title(:show), do: "Show Project"
  defp page_title(:setup), do: "Setup Project"

  @impl true
  def handle_event("delete", _params, socket) do
    Workshop.delete_project(socket.assigns.project)

    {:noreply,
     socket
     |> put_flash(:info, "Project was deleted")
     |> push_redirect(to: Routes.project_index_path(socket, :index))}
  end
end
