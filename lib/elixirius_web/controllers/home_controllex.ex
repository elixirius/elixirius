defmodule ElixiriusWeb.HomeController do
  @moduledoc false

  use ElixiriusWeb, :controller

  def index(%{assigns: %{current_user: nil}} = conn, _params) do
    render(conn, "index.html")
  end

  def index(%{assigns: %{current_user: user}} = conn, _params) do
    redirect(conn, to: "/projects")
  end
end
