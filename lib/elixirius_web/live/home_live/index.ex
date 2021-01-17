defmodule ElixiriusWeb.HomeLive.Index do
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

  @impl true
  def handle_params(_, _, socket) do
    {:noreply, socket}
  end

  # --- Component
  @impl true
  def render(assigns) do
    ~H"""
    <UI.Layouts.AuthLayout flash={{ @flash }} heading="Welcome to Elixirius!">
      <div class="grid place-items-center h-full">
        <nav class="flex items-center space-x-6 text-gray-600">
          <LivePatch to={{ Routes.home_join_path(@socket, :new) }} class="flex items-center space-x-2">
            <UI.Icon name="user-plus" />
            <span>Register</span>
          </LivePatch>

          <LivePatch to={{ Routes.home_enter_path(@socket, :new) }} class="flex items-center space-x-2">
            <UI.Icon name="sign-in" />
            <span>Log in</span>
          </LivePatch>
        </nav>
      </div>
    </UI.Layouts.AuthLayout>
    """
  end
end
