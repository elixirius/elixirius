defmodule SampleAppWeb.HomeLive do
  @moduledoc false

  use SampleAppWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    { :ok, socket }
  end
end
