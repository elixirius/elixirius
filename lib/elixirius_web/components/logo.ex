defmodule ElixiriusWeb.Components.Logo do
  use Surface.Component

  import ElixiriusWeb.Router.Helpers

  alias Surface.Components.LivePatch

  def render(assigns) do
    ~H"""
    <LivePatch to={{ project_index_path(@socket, :index) }}>
      <img src={{ static_path(@socket, "/svg/branding/logo.svg") }} />
    </LivePatch>
    """
  end
end
