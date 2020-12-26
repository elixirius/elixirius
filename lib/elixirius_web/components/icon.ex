defmodule ElixiriusWeb.Components.Icon do
  use Surface.Component

  prop name, :string, required: true
  prop collection, :string, default: "phosphor/regular"
  prop size, :number, default: 6
  prop class, :css_class, default: ""

  def render(assigns) do
    ~H"""
    <span class={{ @class, "icon", "inline-flex", "w-#{@size}", "h-#{ @size }" }}>
      {{ PhoenixInlineSvg.Helpers.svg_image(@socket.endpoint, @name, @collection, class: "h-auto") }}
    </span>
    """
  end
end
