defmodule ElixiriusWeb.ProjectLive.Show do
  @moduledoc false

  use Surface.LiveView

  import ElixiriusWeb.Router.Helpers

  alias Surface.Components.{LiveRedirect, Context}
  alias Elixirius.Workshop
  alias ElixiriusWeb.Components.{Layouts.AppLayout, Modal, Project}

  prop project, :map
  prop current_user, :map
  prop page_title, :string

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
     |> push_redirect(to: project_index_path(socket, :index))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Context put={{ current_user: @current_user, project: @project }}>
      <AppLayout>
        <Modal
          :if={{ @live_action in [:setup] }}
          id={{ "project-setup" }}
          title={{ @page_title }}
          return_to={{ project_show_path(@socket, :show, @project.slug) }}
        >
          <Project.Form
            id="project_form"
            project={{ @project }}
            action={{ @live_action }}
            current_user={{ @current_user }}
            return_to={{ project_show_path(@socket, :show, @project.slug) }}
          />
        </Modal>

        project builder might be here
      </AppLayout>
    </Context>
    """
  end
end
