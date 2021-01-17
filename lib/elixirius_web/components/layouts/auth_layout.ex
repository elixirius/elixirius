defmodule ElixiriusWeb.Components.Layouts.AuthLayout do
  use ElixiriusWeb, :surface_component

  slot default

  prop flash, :map
  prop heading, :string, required: true

  # --- Component

  def render(assigns) do
    ~H"""
    <div class="bg-gray-50 h-full flex flex-col">
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

      <main class="p-8 space-y-6">
        <div class="flex flex-col justify-center items-center space-y-3">
          <UI.Logo
            type="logo"
            class="w-10"
            to={{ Routes.home_index_path(@socket, :index) }}
          />

          <h1 class="text-center text-2xl font-black mb-6">{{ @heading }}</h1>
        </div>

        <div class="p-8 rounded bg-white max-w-sm mx-auto border border-gray-100 shadow-sm">
          <slot />
        </div>

      </main>
    </div>
    """
  end
end
