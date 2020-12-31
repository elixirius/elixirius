defmodule ElixiriusWeb.UserSessionControllerTest do
  use ElixiriusWeb.ConnCase, async: true

  import Elixirius.AccountsFixtures

  setup do
    %{user: user_fixture()}
  end

  # TODO: Update to use Surface views
  # describe "GET /users/log_in" do
  #   test "renders log in page", %{conn: conn} do
  #     conn = get(conn, Routes.user_session_path(conn, :new))
  #     response = html_response(conn, 200)
  #     assert response =~ "Log in</h1>"
  #     assert response =~ "Log in</button>"
  #     assert response =~ "Register</a>"
  #   end

  #   test "redirects if already logged in", %{conn: conn, user: user} do
  #     conn = conn |> log_in_user(user) |> get(Routes.user_session_path(conn, :new))
  #     assert redirected_to(conn) == "/"
  #   end
  # end

  describe "POST /users/log_in" do
    test "logs the user in", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) =~ "/"
    end

    test "logs the user in with remember me", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{
            "email" => user.email,
            "password" => valid_user_password(),
            "remember_me" => "true"
          }
        })

      assert conn.resp_cookies["user_remember_me"]
      assert redirected_to(conn) =~ "/"
    end

    # TODO: Update to use Surface views
    # test "emits error message with invalid credentials", %{conn: conn, user: user} do
    #   conn =
    #     post(conn, Routes.user_session_path(conn, :create), %{
    #       "user" => %{"email" => user.email, "password" => "invalid_password"}
    #     })

    #   response = html_response(conn, 200)
    #   assert response =~ "Log in</h1>"
    #   assert response =~ "Invalid email or password"
    # end
  end

  describe "DELETE /users/log_out" do
    test "logs the user out", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> delete(Routes.user_session_path(conn, :delete))
      assert redirected_to(conn) == "/"
      refute get_session(conn, :user_token)
      assert get_flash(conn, :info) =~ "Logged out successfully"
    end

    test "succeeds even if the user is not logged in", %{conn: conn} do
      conn = delete(conn, Routes.user_session_path(conn, :delete))
      assert redirected_to(conn) == "/"
      refute get_session(conn, :user_token)
      assert get_flash(conn, :info) =~ "Logged out successfully"
    end
  end
end
