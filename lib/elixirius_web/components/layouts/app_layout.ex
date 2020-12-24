defmodule ElixiriusWeb.Components.Layouts.AppLayout do
  use Surface.Component

  alias ElixiriusWeb.Components.Header

  slot default

  def render(assigns) do
    ~H"""
    <div>
      <Header />

      <main class="p-8">
        <slot />
      </main>
    </div>
    """
  end
end
