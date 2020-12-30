defmodule ElixiriusWeb.HomeLive.Enter do
  use ElixiriusWeb, :surface_live_view

  # -- Events

  # @impl true
  def mount(_params, %{"current_user" => user}, socket) do
    {
      :ok,
      socket
      |> assign(:current_user, user)
    }
  end

  # TODO: handle redirect to /project in case of present user
  @impl true
  def handle_params(_, _, socket) do
    {:noreply, socket}
  end

  # --- Component
  @impl true
  def render(assigns) do
    ~H"""
    <UI.Layouts.AuthLayout flash={{ @flash }}>
      <div class="container grid place-items-center h-full">
      </div>
    </UI.Layouts.AuthLayout>
    """
  end
end
