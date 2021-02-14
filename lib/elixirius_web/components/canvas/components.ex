defmodule ElixiriusWeb.Components.Components do
  @moduledoc false
  use Surface.Component

  def render(assigns) do
    ~H"""
    <ul class="flex flex-col space-y-2">
      <li :for={{ component <- available_components() }}>
        <button
          data-component={{ component }}
          draggable="true"
          x-data="{ dragging: false }"
          x-on:dragstart.self="
            dragging = true;
            event.dataTransfer.effectAllowed = 'move';
            event.dataTransfer.setData('text/plain', event.target.dataset.component);
          "
          x-on:dragend="dragging = false"
          class="cursor-move hover:bg-indigo-500 hover:text-white text-gray-500 transition w-full text-xs font-bold flex px-3 py-2 bg-gray-50 rounded">
          {{ component }}
        </button>
      </li>
    </ul>
    """
  end

  # --- Helpers

  defp available_components, do: ["Card"]
end
