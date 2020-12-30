defmodule ElixiriusWeb.Components.Render do
  use Surface.Component

  alias ElixiriusWeb.Components.Element

  prop node, :map, required: true
  prop node_tree, :module, required: true

  def render(assigns) do
    ~H"""
    <Element
      element={{ @node.content.element }}
      id={{ @node.content.id }}>
      <div>
        {{ live_component(
            @socket,
            Module.concat(["ElixiriusWeb","Components", @node.content.element]),
            Map.merge(@node.content.attr, %{__surface__: %{provided_templates: []}})
          )
        }}
      </div>
    </Element>
    """
  end
end
