defmodule ElixiriusWeb.Components.Canvas.Grid do
  use Surface.Component

  prop on_click, :event

  slot default

  def render(assigns) do
    ~H"""
    <div class="flex flex-col w-full flex-1">
      <Context get={{ canvas_id: canvas_id }}>
        <div
          :on-click={{ @on_click }}
          phx-target={{ "#" <> canvas_id }}
          class="flex flex-1 antialiased border-gray-200 text-gray-400"
          style="background-image: radial-gradient(#E5E7EB 1px, #F3F4F6 1px); background-size: 0.5rem 0.5rem;">
          <div class="p-5 flex-1 flex">
            <slot/>
          </div>
        </div>
      </Context>
    </div>
    """
  end
end
