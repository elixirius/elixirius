defmodule ElixiriusWeb.Components.NodeControls do
  use Surface.Component

  alias Surface.Components.Form
  alias Surface.Components.Form.{Field, Label, TextInput}

  prop node, :module, required: true

  def render(assigns) do
    ~H"""
    <Context get={{ canvas_id: canvas_id, update_node_tree: update_node_tree}}>
      <div class="text-sm">
        <Form
          for={{ :node }}
          change={{ update_node_tree }}
          opts={{ "phx-target": "#" <> canvas_id }}>
          <Field name="node_id">
            <TextInput value={{ @node.content.id }} opts={{ hidden: true }} />
          </Field>
          <ul class="flex flex-col space-y-3">
            <li :for={{ prop <- Module.concat(["ElixiriusParts", @node.content.element]).__props__() }}>
              <Field name={{ prop.name }} :if={{ prop.name != :id }}>
                <Label class="font-bold block text-xs text-gray-600">
                  {{ Phoenix.Naming.humanize(prop.name) }}
                </Label>

                <TextInput
                  class="px-3 py-2 text-xs border border-gray-200 rounded outline-none w-full text-gray-600"
                  :if={{ prop.type == :string }} value={{ get_in(@node.content, [:attr, prop.name]) }} />

              </Field>
            </li>
          </ul>
        </Form>
      </div>
    </Context>
    """
  end
end
