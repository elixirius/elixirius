defmodule ElixiriusWeb.UserSessionController do
  @moduledoc false

  use ElixiriusWeb, :controller

  alias Elixirius.Accounts
  alias ElixiriusWeb.{UserAuth, HomeLive}

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      UserAuth.log_in_user(conn, user, user_params)
    else
      live_render(conn, HomeLive.Enter)
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
