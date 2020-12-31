defmodule ElixiriusWeb.Components.Layouts.AuthLayout do
  use ElixiriusWeb, :surface_component

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

      <main class="p-8">
        <div class="flex flex-col justify-center items-center space-y-6">
          <UI.Logo type="logo-full" to={{ Routes.home_index_path(@socket, :index) }} />
        </div>

        <slot />
      </main>
    </div>
    """
  end
end
