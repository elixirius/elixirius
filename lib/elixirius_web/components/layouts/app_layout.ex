defmodule ElixiriusWeb.Components.Layouts.AppLayout do
  use Surface.Component

  alias ElixiriusWeb.Components, as: UI

  slot default

  def render(assigns) do
    ~H"""
    <div>
      <UI.Header />

      <main class="p-8">
        <slot />
      </main>
    </div>
    """
  end
end
