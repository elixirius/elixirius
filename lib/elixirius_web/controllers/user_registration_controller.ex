defmodule ElixiriusWeb.UserRegistrationController do
  @moduledoc false

  use ElixiriusWeb, :controller

  alias Elixirius.Accounts
  alias Elixirius.Accounts.User
  alias ElixiriusWeb.{UserAuth, HomeLive}

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :confirm, &1)
          )

        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        live_render(conn, HomeLive.Join)
    end
  end
end
