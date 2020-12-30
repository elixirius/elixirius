defmodule ElixiriusWeb.Router do
  @moduledoc false

  use ElixiriusWeb, :router

  import ElixiriusWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ElixiriusWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  # Enables LiveDashboard only for development
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ElixiriusWeb.Telemetry
    end
  end

  ## Authentication routes
  scope "/", ElixiriusWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live "/",      HomeLive.Index, :index, session: {__MODULE__, :with_session, []}
    live "/join",  HomeLive.Join,  :new, session: {__MODULE__, :with_session, []}
    live "/enter", HomeLive.Enter, :new, session: {__MODULE__, :with_session, []}

    post "/join", UserRegistrationController, :create
    post "/enter", UserSessionController, :create
    get "/profile/reset_password", UserResetPasswordController, :new
    post "/profile/reset_password", UserResetPasswordController, :create
    get "/profile/reset_password/:token", UserResetPasswordController, :edit
    put "/profile/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", ElixiriusWeb do
    pipe_through [:browser, :require_authenticated_user]

    post "/profile/settings/update_password", UserSettingsController, :update_password
    get "/profile/settings/confirm_email/:token", UserSettingsController, :confirm_email

    live "/profile/settings", ProfileLive.Settings, :edit,
      session: {__MODULE__, :with_session, []}

    live "/projects",      ProjectLive.Index, :index, session: {__MODULE__, :with_session, []}
    live "/projects/new",  ProjectLive.Index, :new,   session: {__MODULE__, :with_session, []}
    live "/:project_slug", ProjectLive.Show,  :show,  session: {__MODULE__, :with_session, []}

    live "/:project_slug/setup", Live.Project.Show, :setup,
      session: {__MODULE__, :with_session, []}
  end

  def with_session(conn), do: %{"current_user" => conn.assigns.current_user}

  scope "/", ElixiriusWeb do
    pipe_through [:browser]

    delete "/profile/log_out", UserSessionController, :delete
    get "/profile/confirm", UserConfirmationController, :new
    post "/profile/confirm", UserConfirmationController, :create
    get "/profile/confirm/:token", UserConfirmationController, :confirm
  end
end
