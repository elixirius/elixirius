defmodule ElixiriusWeb.Components.Header do
  use Surface.Component

  alias ElixiriusWeb.Components, as: UI
  alias Surface.Components.Context

  alias ElixiriusWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~H"""
    <Context get={{ project: project }}>
      <header class="px-4 py-4 flex items-center justify-between border-b border-gray-200">
        <div class="flex items-center">
          <UI.Logo to={{ Routes.project_index_path(@socket, :index) }} />
          <h1
            :if={{ project }}
            class="font-semibold ml-2 text-indigo-700 text-sm"
          >
            {{ project.name }}
          </h1>
        </div>
        <div class="flex items-center space-x-4">
          <UI.ProjectNav :if={{ project }} />
          <span class="text-gray-300" :if={{ project }}>|</span>
          <UI.UserNav />
        </div>
      </header>
    </Context>
    """
  end
end
