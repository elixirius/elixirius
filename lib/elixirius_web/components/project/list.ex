defmodule ElixiriusWeb.Components.Project.List do
  use Surface.Component

  alias Surface.Components.LiveRedirect
  import ElixiriusWeb.Router.Helpers

  prop projects, :list, required: true

  def render(assigns) do
    ~H"""
    <ul class="flex flex-col space-y-3">
      <li :for={{ project <- @projects }}>
        <LiveRedirect
          to={{ project_show_path(@socket, :show, project.slug) }}
          class="flex group items-center space-x-4"
        >
          <i class="ph-browser ph-lg text-gray-400 group-hover:text-indigo-700 transition duration-300 ease-in-out"></i>
          <h2 class="group-hover:text-indigo-700 font-semibold text-sm">{{ project.name }}</h2>
        </LiveRedirect>
      </li>
    </ul>
    """
  end
end
