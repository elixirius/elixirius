defmodule ElixiriusWeb do
  @moduledoc false

  def controller do
    quote do
      use Phoenix.Controller, namespace: ElixiriusWeb

      import Plug.Conn
      import ElixiriusWeb.Gettext
      import Phoenix.LiveView.Controller
      alias ElixiriusWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/elixirius_web/templates",
        namespace: ElixiriusWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      use PhoenixInlineSvg.Helpers

      import Surface

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {ElixiriusWeb.LayoutView, "live.html"}

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  def surface_component do
    quote do
      use Surface.Component

      alias Surface.Components.Context
      alias ElixiriusWeb.Components, as: UI
      alias Surface.Components.LivePatch

      unquote(view_helpers())
    end
  end

  def surface_live_view do
    quote do
      use Surface.LiveView, container: {:div, class: "h-full"}

      alias Surface.Components.Context
      alias ElixiriusWeb.Components, as: UI
      alias Surface.Components.LivePatch

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import ElixiriusWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView helpers (live_render, live_component, live_patch, etc)
      import Phoenix.LiveView.Helpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import ElixiriusWeb.ErrorHelpers
      import ElixiriusWeb.Gettext
      alias ElixiriusWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
