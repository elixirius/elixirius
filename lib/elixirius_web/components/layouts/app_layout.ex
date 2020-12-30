defmodule ElixiriusWeb.Components.Layouts.AppLayout do
  use Surface.Component

  alias ElixiriusWeb.Components, as: UI

  slot default

  prop flash, :map
  prop no_padding, :boolean, default: false

  # --- Component

  def render(assigns) do
    ~H"""
    <div class="flex flex-col h-full">
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

      <main class={{ "flex-1", "p-4": !@no_padding }}>
        <slot />
      </main>
    </div>
    """
  end
end
