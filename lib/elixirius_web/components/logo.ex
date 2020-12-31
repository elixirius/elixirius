defmodule ElixiriusWeb.Components.Logo do
  use ElixiriusWeb, :surface_component

  prop to, :string, required: true
  prop type, :string, default: "logo"

  def render(assigns) do
    ~H"""
    <LivePatch to={{ @to }}>
      <img src={{ Routes.static_path(@socket, "/svg/branding/#{@type}.svg") }} />
    </LivePatch>
    """
  end
end
