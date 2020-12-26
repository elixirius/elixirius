defmodule ElixiriusWeb.Components.Layouts.AppLayout do
  use Surface.Component

  alias ElixiriusWeb.Components, as: UI

  slot default

  prop flash, :map

  # --- Component

  def render(assigns) do
    ~H"""
    <div>
      <p
        :if={{ live_flash(@flash, :info) }}
        class="alert alert-info"
        role="alert"
      >
        {{ live_flash(@flash, :info) }}
      </p>

      <p
        :if={{ live_flash(@flash, :error) }}
        class="alert alert-danger"
        role="alert"
      >
        {{ live_flash(@flash, :error) }}
      </p>

      <UI.Header />

      <main class="p-8">
        <slot />
      </main>
    </div>
    """
  end
end
