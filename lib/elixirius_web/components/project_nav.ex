defmodule ElixiriusWeb.Components.ProjectNav do
  use Surface.Component

  import ElixiriusWeb.Router.Helpers

  alias Surface.Components.{LiveRedirect, Context}
  alias ElixiriusWeb.Components, as: UI

  def render(assigns) do
    ~H"""
    <Context get={{ project: project }}>
      <nav class="flex items-center space-x-4 text-gray-500">
        <LiveRedirect class="flex items-center" to={{ project_show_path(@socket, :setup, project.slug) }}>
          <UI.Icon name="wrench" />
        </LiveRedirect>

        <a href="#" class="flex items-center">
          <UI.Icon name="play" />
        </a>

        <a href="#" class="flex items-center">
          <UI.Icon name="eye" />
        </a>
      </nav>
    </Context>
    """
  end
end
