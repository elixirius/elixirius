defmodule ElixiriusWeb.UserRegistrationControllerTest do
  use ElixiriusWeb.ConnCase, async: true

  # TODO: Update to LiveView test

  # import Elixirius.AccountsFixtures

  # describe "GET /users/register" do
  #   test "renders registration page", %{conn: conn} do
  #     conn = get(conn, Routes.user_registration_path(conn, :new))
  #     response = html_response(conn, 200)
  #     assert response =~ "Register</h1>"
  #     assert response =~ "Log in</a>"
  #     assert response =~ "Register</button>"
  #   end

  #   test "redirects if already logged in", %{conn: conn} do
  #     conn = conn |> log_in_user(user_fixture()) |> get(Routes.user_registration_path(conn, :new))
  #     assert redirected_to(conn) == "/"
  #   end
  # end

  # describe "POST /users/register" do
  #   @tag :capture_log
  #   test "creates account and logs the user in", %{conn: conn} do
  #     email = unique_user_email()
  #     name = "Tester"

  #     conn =
  #       post(conn, Routes.user_registration_path(conn, :create), %{
  #         "user" => %{"name" => name, "email" => email, "password" => valid_user_password()}
  #       })

  #     assert get_session(conn, :user_token)
  #     assert redirected_to(conn) =~ "/"
  #   end

  #   test "render errors for invalid data", %{conn: conn} do
  #     conn =
  #       post(conn, Routes.user_registration_path(conn, :create), %{
  #         "user" => %{"email" => "with spaces", "password" => "too short"}
  #       })

  #     response = html_response(conn, 200)
  #     assert response =~ "Register</h1>"
  #     assert response =~ "must have the @ sign and no spaces"
  #     assert response =~ "should be at least 12 character"
  #   end
  # end
end
