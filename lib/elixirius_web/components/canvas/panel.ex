defmodule ElixiriusWeb.Components.Panel do
  @moduledoc """
  A simple horizontal navigation **tabs** component
  """

  use Surface.LiveComponent

  alias ElixiriusWeb.Components.Icon

  @doc "The tabs to display"
  slot tabs, required: true

  data active_tab, :integer, default: 0

  def render(assigns) do
    ~H"""
    <div class="w-full bg-white">
      <nav>
        <ul class="bg-white flex w-full">
          <li :for={{ {tab, index} <- Enum.with_index(@tabs), tab.visible }}>
            <a
              :on-click="tab_click"
              phx-value-index={{ index }}
              title={{ tab.label }}
              class={{
                "py-2 px-4 flex overflow-hidden border-r border-gray-200 cursor-pointer",
                "text-indigo-500 bg-indigo-50": @active_tab == index,
                "text-gray-400": @active_tab != index
              }}>
              <Icon :if={{ tab.icon }} name={{ tab.icon }} size={{ 4 }} />
            </a>
          </li>
        </ul>
      </nav>
      <section class="overflow-hidden border-t border-gray-200 w-full p-2">
        <div
          :for={{ {tab, index} <- Enum.with_index(@tabs) }}
          :show={{ tab.visible && @active_tab == index }}
        >
          <slot name="tabs" index={{ index }}/>
        </div>
      </section>
    </div>
    """
  end

  # --- Events

  def handle_event("tab_click", %{"index" => index_str}, socket) do
    index = String.to_integer(index_str)
    {:noreply, assign(socket, active_tab: index)}
  end
end
