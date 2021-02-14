defmodule ElixiriusWeb.Components.Page do
  use Surface.Component

  prop id, :string, required: true
  prop canvas_id, :string, required: true

  slot default

  def render(assigns) do
    ~H"""
    <div
      id={{ "page--" <> @id }}
      phx-hook="LiveViewPushEvent"
      x-on:drop=""
      x-on:dragover.prevent="adding = true"
      x-on:dragleave.prevent="adding = false"
      x-on:drop.prevent={{"
        adding = false;

        const component = event.dataTransfer.getData('text/plain');

        $dispatch('liveview-push-event-to', {
          selector: '#" <> @canvas_id <> "',
          event: 'drop_node',
          payload: {
            component
          }
        })
      "}}
      class="bg-white w-full p-8 overflow-auto max-w-7xl border border-gray-200 mx-auto text-gray-700 flex-1"
      :class="{ 'bg-indigo-50 border-indigo-500': adding }">
      <slot />
    </div>
    """
  end
end
