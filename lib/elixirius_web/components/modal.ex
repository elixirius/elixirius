defmodule ElixiriusWeb.Components.Modal do
  use Surface.LiveComponent

  alias Surface.Components.LivePatch

  slot default, required: true

  prop return_to, :any
  prop title, :string

  @impl true
  def render(assigns) do
    ~H"""
    <div
      id={{ @id }}
      class="fixed z-50 inset-0 bg-gray-900 bg-opacity-50"
      :on-capture-click="close"
      :on-window-keydown="close"
      phx-key="escape"
      phx-page-loading
    >
      <div class="bg-white rounded max-w-5xl mx-auto shadow mt-16 p-8">
        <div class="relative flex items-center border-b border-gray-100 mb-6 pb-3">
          <h3
            :if={{ @title }}
            class="font-sm font-bold text-indigo-700"
          >
            {{ @title }}
          </h3>

          <LivePatch to={{ @return_to }} class="absolute right-0 top-0">
            <i class="ph-x-circle ph-xl text-gray-500 hover:text-indigo-700 transition duration-300 ease-in-out"></i>
          </LivePatch>
        </div>

        <div>
          <slot />
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
