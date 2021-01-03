defmodule ElixiriusWeb.Components.Element do
  use Surface.Component

  alias ElixiriusWeb.Components.Icon

  prop id, :string
  prop element, :string

  @doc "The main content"
  slot default, required: true

  def render(assigns) do
    ~H"""
    <span>
      <Context get={{
        active_component_id: active_component_id,
        set_active_component_id: set_active_component_id,
        remove_node_from_tree: remove_node_from_tree,
        canvas_id: canvas_id
      }}>
        <div
          id={{ @id }}
          class={{
            "relative cursor-pointer select-none transition",
            "z-50 ring-1 ring-indigo-500": active_component_id == @id,
            "z-0 ring-0": active_component_id != @id
          }}
          :on-click={{ set_active_component_id }}
          phx-target={{ "#" <> canvas_id }}
          phx-value-id={{ @id }}>
          <div class="relative">
            <div
              :if={{ active_component_id == @id }}
              class="absolute flex w-full justify-between -top-6 left-0 -ml-px">
              <div class="px-2 py-1 bg-indigo-500 h-full text-white text-xs font-bold flex items-center">
                {{ @element }} :: {{ @id }}
              </div>
              <button
                :on-click={{ remove_node_from_tree }}
                phx-target={{ "#" <> canvas_id }}
                phx-value-id={{ @id }}
                class="flex justify-center p-0 text-red-600 -mr-px">
                <Icon name="trash-simple" size={{ 5 }} />
              </button>
            </div>
            <slot/>
          </div>
        </div>
      </Context>
    </span>
    """
  end
end
