defmodule ElixiriusWeb.UserSettingsController do
  @moduledoc false

  use ElixiriusWeb, :controller

  alias Elixirius.Accounts
  alias ElixiriusWeb.UserAuth

  plug :assign_email_and_password_changesets

  def confirm_email(conn, %{"token" => token}) do
    case Accounts.update_user_email(conn.assigns.current_user, token) do
      :ok ->
        conn
        |> put_flash(:info, "Email changed successfully.")
        |> redirect(to: Routes.profile_settings_path(conn, :edit))

      :error ->
        conn
        |> put_flash(:error, "Email change link is invalid or it has expired.")
        |> redirect(to: Routes.profile_settings_path(conn, :edit))
    end
  end

  def update_password(conn, %{"user" => user_params}) do
    user = conn.assigns.current_user

    case Accounts.update_user_password(user, user_params["current_password"], user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Password updated successfully.")
        |> put_session(:user_return_to, Routes.profile_settings_path(conn, :edit))
        |> UserAuth.log_in_user(user)

      {:error, _changeset} ->
        redirect(conn, to: Routes.profile_settings_path(conn, :edit))
    end
  end

  defp assign_email_and_password_changesets(conn, _opts) do
    user = conn.assigns.current_user

    conn
    |> assign(:email_changeset, Accounts.change_user_email(user))
    |> assign(:password_changeset, Accounts.change_user_password(user))
  end
end
