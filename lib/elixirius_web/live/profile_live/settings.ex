defmodule ElixiriusWeb.ProfileLive.Settings do
  use ElixiriusWeb, :surface_live_view

  prop page_title, :string, default: "Profile Settings"
  prop current_user, :map

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

  @impl true
  def render(assigns) do
    ~H"""
    <Context put={{ current_user: @current_user }}>
      <UI.Layouts.AppLayout flash={{ @flash }}>
        <UI.Profile.Form id="profile_settings" />
      </UI.Layouts.AppLayout>
    </Context>
    """
  end
end
