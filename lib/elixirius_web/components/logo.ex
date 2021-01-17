defmodule ElixiriusWeb.Components.Logo do
  use ElixiriusWeb, :surface_component

  prop to, :string, required: true
  prop type, :string, default: "logo"
  prop class, :css_class, default: []

  def render(assigns) do
    ~H"""
    <LivePatch to={{ @to }}>
      {{ PhoenixInlineSvg.Helpers.svg_image(
        @socket.endpoint,
        @type,
        "branding",
        class: "h-auto " <> Enum.join(@class)
      ) }}
    </LivePatch>
    """
  end
end
