defmodule ElixiriusWeb.Components.Header do
  use Surface.Component

  alias ElixiriusWeb.Components, as: UI
  alias Surface.Components.Context

  def render(assigns) do
    ~H"""
    <Context get={{ project: project }}>
      <header class="px-8 py-4 flex items-center justify-between border-b border-gray-100">
        <div class="flex items-center">
          <UI.Logo />
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
