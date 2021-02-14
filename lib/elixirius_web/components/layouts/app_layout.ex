defmodule ElixiriusWeb.Components.Layouts.AppLayout do
  use Surface.Component

  alias ElixiriusWeb.Components, as: UI

  slot default

  prop flash_payload, :map
  prop no_padding, :boolean, default: false

  # --- Component

  def render(assigns) do
    ~H"""
    <div class="flex flex-col h-full">
      <p
        :if={{ live_flash(@flash_payload, :info) }}
        class="alert alert-info"
        role="alert"
      >
        {{ live_flash(@flash_payload, :info) }}
      </p>

      <p
        :if={{ live_flash(@flash_payload, :error) }}
        class="alert alert-danger"
        role="alert"
      >
        {{ live_flash(@flash_payload, :error) }}
      </p>

      <UI.Header />

      <main class={{ "flex-1", "p-4": !@no_padding }}>
        <slot />
      </main>
    </div>
    """
  end
end
