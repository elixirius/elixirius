defmodule ElixiriusWeb.ProjectLive.Index do
  @moduledoc false

  use Surface.LiveView

  import ElixiriusWeb.Router.Helpers

  alias Elixirius.Workshop
  alias Elixirius.Workshop.Project
  alias Surface.Components.{LivePatch, LiveRedirect, Context}
  alias ElixiriusWeb.Components.{Layouts.AppLayout, Modal, Project.Form, Project.List}

  prop projects, :list
  prop project, :map
  prop page_title, :string
  prop current_user, :map

  # -- Events

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
  @spec handle_params(any, any, Phoenix.LiveView.Socket.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  # --- Helpers

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

  # --- Component

  @impl true
  def render(assigns) do
    ~H"""
    <Context put={{ current_user: @current_user }}>
      <AppLayout>
        <div class="flex justify-between items-center">
          <h2 class="text-sm upercase font-bold text-indigo-700 mb-4">My Projects:</h2>

          <LivePatch
            to={{ project_index_path(@socket, :new) }}
            class="text-sm flex items-center space-x-2 font-bold px-6 py-2 rounded bg-indigo-700 text-white transition duration-300 ease-in-out hover:bg-indigo-800"
          >
            <i class="ph-plus-circle ph-lg"></i>
            <span>New Project</span>
          </LivePatch>
        </div>

        <Modal
          :if={{ @live_action in [:new] }}
          title={{ @page_title }}
          id="new_project_modal"
          return_to={{ project_index_path(@socket, :index) }}
        >
          <Form
            id="new_project_form"
            project={{ @project }}
            action={{ @live_action }}
            current_user={{ @current_user }}
            return_to={{ project_index_path(@socket, :index) }}
          />
        </Modal>

        <List projects={{ @projects }} />
      </AppLayout>
    </Context>
    """
  end
end
