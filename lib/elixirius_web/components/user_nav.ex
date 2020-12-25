defmodule ElixiriusWeb.Components.UserNav do
  use Surface.Component

  import Phoenix.HTML.{Link, Tag}
  import ElixiriusWeb.Router.Helpers

  alias Surface.Components.{LiveRedirect, Context, Link}

  def render(assigns) do
    ~H"""
    <Context get={{ current_user: current_user }}>
      <nav>
        <div :if={{ current_user }} class="flex items-center space-x-6">
          <div class="flex items-center space-x-4 text-gray-500 transition hover:text-grape-500">
            <LiveRedirect
              to={{ project_index_path(@socket, :index) }}
              class="flex items-center"
            >
              <i class="ph-browsers ph-xl text-gray-500"></i>
            </LiveRedirect>

            <LiveRedirect
              to={{ profile_settings_path(@socket, :edit) }}
              class="flex items-center"
            >
              <i class="ph-user-circle-gear ph-xl text-gray-500"></i>
            </LiveRedirect>

            <Link
              to={{ user_session_path(@socket, :delete) }}
              opts={{ method: :delete }}
              class="flex items-center"
            >
              <i class="ph-sign-out ph-xl text-gray-500"></i>
            </Link>
          </div>
        </div>
        <div :if={{ is_nil(current_user) }}>
          <LiveRedirect to={{ user_registration_path(@socket, :new) }}>
            Register
          </LiveRedirect>

          <LiveRedirect to={{ user_session_path(@socket, :new) }}>
            Log in
          </LiveRedirect>
        </div>
      </nav>
    </Context>
    """
  end
end
