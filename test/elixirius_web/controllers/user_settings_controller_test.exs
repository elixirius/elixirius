defmodule ElixiriusWeb.UserSettingsControllerTest do
  use ElixiriusWeb.ConnCase, async: true

  alias Elixirius.Accounts
  import Elixirius.AccountsFixtures

  setup :register_and_log_in_user

  describe "GET /profile/settings" do
    test "renders settings page", %{conn: conn} do
      conn = get(conn, Routes.profile_settings_path(conn, :edit))
      response = html_response(conn, 200)
      assert response =~ "Change Email:"
    end

    test "redirects if user is not logged in" do
      conn = build_conn()
      conn = get(conn, Routes.profile_settings_path(conn, :edit))
      assert redirected_to(conn) == Routes.user_session_path(conn, :new)
    end
  end

  # TODO: Update to use Surface views
  # describe "PUT /users/settings/update_password" do
  #   test "updates the user password and resets tokens", %{conn: conn, user: user} do
  #     new_password_conn =
  #       put(conn, Routes.profile_settings_path(conn, :update_password), %{
  #         "current_password" => valid_user_password(),
  #         "user" => %{
  #           "password" => "new valid password",
  #           "password_confirmation" => "new valid password"
  #         }
  #       })

  #     assert redirected_to(new_password_conn) == Routes.profile_settings_path(conn, :edit)
  #     assert get_session(new_password_conn, :user_token) != get_session(conn, :user_token)
  #     assert get_flash(new_password_conn, :info) =~ "Password updated successfully"
  #     assert Accounts.get_user_by_email_and_password(user.email, "new valid password")
  #   end

  #   test "does not update password on invalid data", %{conn: conn} do
  #     old_password_conn =
  #       put(conn, Routes.profile_settings_path(conn, :update_password), %{
  #         "current_password" => "invalid",
  #         "user" => %{
  #           "password" => "too short",
  #           "password_confirmation" => "does not match"
  #         }
  #       })

  #     response = html_response(old_password_conn, 200)
  #     assert response =~ "Change Email:"
  #     assert response =~ "should be at least 12 character(s)"
  #     assert response =~ "does not match password"
  #     assert response =~ "is not valid"

  #     assert get_session(old_password_conn, :user_token) == get_session(conn, :user_token)
  #   end
  # end

  # TODO: Update to use Surface views
  # describe "PUT /users/settings/update_email" do
  #   @tag :capture_log
  #   test "updates the user email", %{conn: conn, user: user} do
  #     conn =
  #       put(conn, Routes.profile_settings_path(conn, :update_email), %{
  #         "current_password" => valid_user_password(),
  #         "user" => %{"email" => unique_user_email()}
  #       })

  #     assert redirected_to(conn) == Routes.profile_settings_path(conn, :edit)
  #     assert get_flash(conn, :info) =~ "A link to confirm your email"
  #     assert Accounts.get_user_by_email(user.email)
  #   end

  #   test "does not update email on invalid data", %{conn: conn} do
  #     conn =
  #       put(conn, Routes.profile_settings_path(conn, :update_email), %{
  #         "current_password" => "invalid",
  #         "user" => %{"email" => "with spaces"}
  #       })

  #     response = html_response(conn, 200)
  #     assert response =~ "Change Email:"
  #     assert response =~ "must have the @ sign and no spaces"
  #     assert response =~ "is not valid"
  #   end
  # end

  describe "GET /users/settings/confirm_email/:token" do
    setup %{user: user} do
      email = unique_user_email()

      token =
        extract_user_token(fn url ->
          Accounts.deliver_update_email_instructions(%{user | email: email}, user.email, url)
        end)

      %{token: token, email: email}
    end

    test "updates the user email once", %{conn: conn, user: user, token: token, email: email} do
      conn = get(conn, Routes.user_settings_path(conn, :confirm_email, token))
      assert redirected_to(conn) == Routes.profile_settings_path(conn, :edit)
      assert get_flash(conn, :info) =~ "Email changed successfully"
      refute Accounts.get_user_by_email(user.email)
      assert Accounts.get_user_by_email(email)

      conn = get(conn, Routes.user_settings_path(conn, :confirm_email, token))
      assert redirected_to(conn) == Routes.profile_settings_path(conn, :edit)
      assert get_flash(conn, :error) =~ "Email change link is invalid or it has expired"
    end

    test "does not update email with invalid token", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_settings_path(conn, :confirm_email, "oops"))
      assert redirected_to(conn) == Routes.profile_settings_path(conn, :edit)
      assert get_flash(conn, :error) =~ "Email change link is invalid or it has expired"
      assert Accounts.get_user_by_email(user.email)
    end

    test "redirects if user is not logged in", %{token: token} do
      conn = build_conn()
      conn = get(conn, Routes.user_settings_path(conn, :confirm_email, token))
      assert redirected_to(conn) == Routes.user_session_path(conn, :new)
    end
  end
end
