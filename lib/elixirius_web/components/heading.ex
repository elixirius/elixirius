defmodule ElixiriusWeb.Components.Heading do
  use ElixiriusWeb, :surface_component

  slot default

  def render(assigns) do
    ~H"""
    <h1 class="font-bold text-lg text-indigo-700">
      <slot />
    </h1>
    """
  end
end
