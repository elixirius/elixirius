defmodule ElixiriusWeb.Components.Modal do
  use Surface.LiveComponent

  alias Surface.Components.LivePatch

  prop return_to, :any

  @impl true
  def render(assigns) do
    ~H"""
    <div id={{ @id }} class="phx-modal"
      phx-capture-click="close"
      phx-window-keydown="close"
      phx-key="escape"
      phx-target="#{{ @id }}"
      phx-page-loading
    >
      <div class="phx-modal-content">
        <LivePatch to={{ @return_to }} class="phx-modal-close">
          <i class="ph-x-circle"></i>
        </LivePatch>
        <slot />
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
