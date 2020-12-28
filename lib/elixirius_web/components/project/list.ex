defmodule ElixiriusWeb.Components.Project.List do
  use Surface.Component

  alias Surface.Components.LiveRedirect
  alias ElixiriusWeb.Components, as: UI

  import ElixiriusWeb.Router.Helpers

  prop projects, :list, required: true

  def render(assigns) do
    ~H"""
    <ul class="flex flex-col">
      <li :for={{ project <- @projects }}>
        <LiveRedirect
          to={{ project_show_path(@socket, :show, project.slug) }}
          class="flex group items-center space-x-4 py-2 transition duration-300 ease-in-out"
        >
          <UI.Icon name="browser" class="text-gray-400 group-hover:text-indigo-700 transition duration-300 ease-in-out" />
          <h2 class="group-hover:text-indigo-700 font-semibold text-sm">{{ project.name }}</h2>
        </LiveRedirect>
      </li>
    </ul>
    """
  end
end
