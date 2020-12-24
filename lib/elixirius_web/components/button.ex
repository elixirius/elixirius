defmodule ElixiriusWeb.Components.Button do
  use Surface.Component

  slot default, required: true
  prop on_click, :event

  # --- Component

  def render(assigns) do
    ~H"""
    <button class="rounded bg-violet-700 text-white font-semibold">
      <slot />
    </button>
    """
  end
end
