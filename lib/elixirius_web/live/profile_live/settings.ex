defmodule ElixiriusWeb.ProfileLive.Settings do
  use Surface.LiveView

  import ElixiriusWeb.Router.Helpers

  alias Elixirius.Workshop
  alias Elixirius.Workshop.Project
  alias Surface.Components.{LivePatch, LiveRedirect, Context}
  alias ElixiriusWeb.Components.{Layouts.AppLayout, Modal, Project.Form, Project.List}

  # -- Events

  @impl true
  def mount(_params, %{"current_user" => user}, socket) do
    {
      :ok,
      socket
      |> assign(:current_user, user)
    }
  end

  # --- Component

  def render(assigns) do
    ~H"""
    <div>Profile settings</div>
    """
  end
end
