defmodule ElixiriusWeb.Components.ProjectNav do
  use Surface.Component

  import ElixiriusWeb.Router.Helpers

  alias Surface.Components.{LiveRedirect, Context}

  def render(assigns) do
    ~H"""
    <Context get={{ project: project }}>
      <nav class="flex items-center space-x-4">
        <LiveRedirect class="flex items-center" to={{ project_show_path(@socket, :setup, project.slug) }}>
          <i class="ph-wrench ph-xl text-gray-500"></i>
        </LiveRedirect>

        <a href="#" class="flex items-center">
          <i class="ph-play ph-xl text-gray-500"></i>
        </a>

        <a href="#" class="flex items-center">
          <i class="ph-eye ph-xl text-gray-500"></i>
        </a>
      </nav>
    </Context>
    """
  end
end
