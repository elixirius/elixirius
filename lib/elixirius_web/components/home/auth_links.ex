defmodule ElixiriusWeb.Components.Home.AuthLinks do
  use ElixiriusWeb, :surface_component

  prop register, :boolean, default: false
  prop enter, :boolean, default: false
  prop forgot_password, :boolean, default: false

  def render(assigns) do
    ~H"""
    <nav class="flex flex-col space-y-1 text-indigo-700 text-center text-sm font-medium">
      <LivePatch :if={{ @register }} to={{ Routes.home_join_path(@socket, :new) }}>
        Create new account
      </LivePatch>

      <LivePatch :if={{ @enter }} to={{ Routes.home_enter_path(@socket, :new) }}>
        Sign in
      </LivePatch>

      <LivePatch :if={{ @forgot_password }} to={{ Routes.home_forgot_password_path(@socket, :new) }}>
        Forgot your password?
      </LivePatch>
    </nav>
    """
  end
end
