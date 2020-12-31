defmodule ElixiriusWeb.ProjectLive.Index do
  @moduledoc false

  use Surface.LiveView

  import ElixiriusWeb.Router.Helpers

  alias Elixirius.Workshop
  alias Elixirius.Workshop.Project
  alias Surface.Components.{LivePatch, Context}
  alias ElixiriusWeb.Components, as: UI

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
      <UI.Layouts.AppLayout flash={{ @flash }}>
        <div
          :if={{ Enum.count(@projects) > 0 }}
          class="flex justify-between items-center">
          <h2 class="text-sm upercase font-bold text-indigo-700 mb-4">My Projects:</h2>

          <LivePatch
            to={{ project_index_path(@socket, :new) }}
            class="button button-primary"
          >
            <UI.Icon name="plus-circle" />

            <span>New Project</span>
          </LivePatch>
        </div>

        <div
          :if={{ Enum.empty?(@projects) }}
          class="flex justify-center text-center max-w-4xl mx-auto flex-col space-y-6"
        >
          <p class="text-xl">
            You have no projects. <br />
            Create a new one to see how awesome <strong>Elixirius</strong> is!
          </p>

          <LivePatch
            to={{ project_index_path(@socket, :new) }}
            class="button button-primary"
          >
            <UI.Icon name="plus-circle" />
            <span>New Project</span>
          </LivePatch>
        </div>

        <UI.Modal
          :if={{ @live_action in [:new] }}
          title={{ @page_title }}
          id="new_project_modal"
          return_to={{ project_index_path(@socket, :index) }}
        >
          <UI.Project.Form
            id="new_project_form"
            project={{ @project }}
            action={{ @live_action }}
            return_to={{ project_index_path(@socket, :index) }}
          />
        </UI.Modal>

        <UI.Project.List
          :if={{ Enum.count(@projects) > 0 }}
          projects={{ @projects }} />
      </UI.Layouts.AppLayout>
    </Context>
    """
  end
end
