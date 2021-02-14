defmodule ElixiriusWeb.Components.NodeTree do
  @moduledoc false
  use Surface.Component

  import Elixirius.State

  alias ElixiriusWeb.Components.Icon

  @doc "The title"
  prop nodes, :module, required: true

  def render(assigns) do
    ~H"""
    <div>
      <div class="flex flex-col">
        <ul class="space-y-2 mt-2">
          <li :for={{ page <- get_pages(@nodes) }} class="mx-2">

            <h3 class="text-xs font-bold text-gray-900 mb-3 uppercase tracking-wide">Pages</h3>

            <h4 class="mb-3">
              <div class="p-2 flex items-center space-x-1 bg-gray-100 rounded mb-2">
                <Icon name="file" size={{ 4 }} class={{ "text-gray-400" }} />
                <span class="text-gray-500 font-bold text-xs">{{ page.content.title }}</span>
              </div>
            </h4>

            <h3 class="text-xs font-bold text-gray-900 mb-3 uppercase tracking-wide">Layers</h3>
            {{ render_node(assigns, get_page_nodes(@nodes, page.content.id)) }}
          </li>
        </ul>
      </div>
    </div>
    """
  end

  def render_node(assigns, nodes) do
    ~H"""
    <ul class="space-y-1">
      <Context get={{
        active_component_id: active_component_id,
        set_active_component_id: set_active_component_id,
        canvas_id: canvas_id
      }}>
        <For each={{ node <- nodes }}>
          <li id={{ node.content.id }}>
            <button
              class={{
                "p-2 w-full border text-xs flex space-x-2 rounded transition justify-start",
                "border-indigo-500 bg-indigo-500 text-white hover:bg-indigo-500": active_component_id == node.content.id,
                "bg-gray-50 border-gray-100 hover:bg-gray-100 text-gray-500": active_component_id != node.content.id
              }}
              :on-click={{ set_active_component_id }}
              phx-target="#{{ canvas_id }}"
              phx-value-id={{ node.content.id }}
              title={{ node.content.id }}>
              <span class="font-bold">
                {{ node.content.element }}
              </span>
            </button>
          </li>
        </For>
      </Context>
    </ul>
    """
  end
end
