defmodule ElixiriusWeb.Components.UserNav do
  use Surface.Component

  import ElixiriusWeb.Router.Helpers

  alias Surface.Components.{LiveRedirect, Context, Link}
  alias ElixiriusWeb.Components, as: UI

  def render(assigns) do
    ~H"""
    <Context get={{ current_user: current_user }}>
      <nav>
        <div :if={{ current_user }} class="flex items-center space-x-6">
          <div class="flex items-center space-x-4 text-gray-500">
            <LiveRedirect
              to={{ project_index_path(@socket, :index) }}
              class="flex items-center"
            >
              <UI.Icon name="browsers" />
            </LiveRedirect>

            <LiveRedirect
              to={{ profile_settings_path(@socket, :edit) }}
              class="flex items-center"
            >
              <UI.Icon name="user-circle-gear" />
            </LiveRedirect>

            <Link
              to={{ user_session_path(@socket, :delete) }}
              opts={{ method: :delete }}
              class="flex items-center"
            >
              <span class="icon inline-flex w-6 h-6">
                {{ PhoenixInlineSvg.Helpers.svg_image(@socket.endpoint, "sign-out", "phosphor/regular", class: "h-auto") }}
              </span>
            </Link>
          </div>
        </div>
        <div :if={{ is_nil(current_user) }}>
          <LiveRedirect to={{ user_registration_path(@socket, :create) }}>
            Register
          </LiveRedirect>

          <LiveRedirect to={{ user_session_path(@socket, :create) }}>
            Log in
          </LiveRedirect>
        </div>
      </nav>
    </Context>
    """
  end
end
