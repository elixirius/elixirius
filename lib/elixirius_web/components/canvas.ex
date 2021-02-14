defmodule ElixiriusWeb.Components.Canvas do
  @moduledoc false
  use Surface.LiveComponent

  import Elixirius.State

  alias ElixiriusWeb.Components.{
    Render,
    NodeTree,
    NodeDocs,
    NodeControls,
    Panel,
    PanelItem,
    Components,
    Page,
    Canvas
  }

  data active_component_id, :string, default: nil
  data active_page_id, :string, default: get_default_page_id(get_default_state())
  data node_tree, :module, default: get_default_state()

  prop set_active_component_id, :event, default: "set_active_component_id"
  prop set_active_page_id, :event, default: "set_active_page_id"
  prop update_node_tree, :event, default: "update_node_tree"
  prop remove_node_from_tree, :event, default: "remove_node_from_tree"
  prop reset_component_selection, :event, default: "reset_component_selection"

  def render(assigns) do
    ~H"""
    <div
      id={{ @id }}
      x-data="{ adding: false, removing: false }"
      class="flex flex-1 h-full">
      <Context put={{
        canvas_id: @id,
        active_component_id: @active_component_id,
        set_active_component_id: @set_active_component_id,
        update_node_tree: @update_node_tree,
        remove_node_from_tree: @remove_node_from_tree
      }}>

        <!-- START Left Panel -->
        <div class="border-r border-gray-200 w-64">
          <Panel id="node_tree">
            <PanelItem label="Node Tree" icon="stack">
              <NodeTree nodes={{ @node_tree }} />
            </PanelItem>

            <PanelItem label="Elements" icon="squares-four">
              <Components />
            </PanelItem>

            <PanelItem label="Data" icon="database">
              Data elements will be here soon...
            </PanelItem>
          </Panel>
        </div>
        <!-- END Left Panel -->

        <!-- START Main Canvas -->
        <div class="flex flex-col w-full flex-1">
          <!-- START Grid -->
          <Canvas.Grid on_click={{ @reset_component_selection }}>
            <Page id={{ @active_page_id }} canvas_id={{ @id }}>
              <div
                :for={{ node <- get_default_page_nodes(@node_tree) }}>
                <Render node_tree={{ @node_tree }} node={{ node }} />
              </div>
            </Page>
          </Canvas.Grid>
          <!-- END Grid -->

          <!-- START Bottom Panel -->
          <div class="border-t border-gray-200">
            <Panel id="project_data">
              <PanelItem label="Node Tree State" icon="code">
                <div class="overflow-auto h-64 text-xs">
                  {{ raw Makeup.highlight(Jason.encode!(NaryTree.to_map(@node_tree), pretty: true)) }}
                  <style>{{ Makeup.stylesheet() }} .highlight { background-color: white;}</style>
                </div>
              </PanelItem>
            </Panel>
          </div>
          <!-- END Bottom Panel -->

        </div>
        <!-- END Main Canvas -->

        <!-- START Right Panel -->
        <div class="border-l border-gray-200 w-64" :if={{ @active_component_id != nil }}>
          <Panel id="node_details">
            <PanelItem label="Controls" icon="sliders">
              <NodeControls node={{ get_node_by_id(@node_tree, @active_component_id) }} />
            </PanelItem>

            <PanelItem label="Events" icon="lightning">
              Node events controls will be here...
            </PanelItem>

            <PanelItem label="Docs" icon="info">
              <NodeDocs node={{ get_node_by_id(@node_tree, @active_component_id) }} />
            </PanelItem>
          </Panel>
        </div>
        <!-- END Right Panel -->

      </Context>
    </div>
    """
  end

  # --- Events

  def mount(socket) do
    {:ok, assign(socket, node_tree: get_default_state())}
  end

  def handle_event("set_active_component_id", value, socket) do
    {:noreply, assign(socket, active_component_id: value["id"])}
  end

  def handle_event("reset_component_selection", _value, socket) do
    {:noreply, assign(socket, active_component_id: nil)}
  end

  def handle_event("drop_node", %{"component" => component}, socket) do
    new_tree = append_node(socket.assigns.node_tree, component)
    {:noreply, socket |> assign(node_tree: new_tree)}
  end

  def handle_event("update_node_tree", %{"node" => node}, socket) do
    current_node_id = get_node_by_id(socket.assigns.node_tree, node["node_id"]).id

    {_get, new_content} =
      Map.get_and_update(
        NaryTree.get(socket.assigns.node_tree, current_node_id).content,
        :attr,
        &{&1, Map.merge(&1, map_keys_to_atoms(Map.drop(node, ["id", "node_id"])))}
      )

    {_old_node, new_tree} =
      NaryTree.get_and_update(
        socket.assigns.node_tree,
        current_node_id,
        &{&1, %NaryTree.Node{&1 | content: new_content}}
      )

    {:noreply,
     socket
     |> assign(node_tree: new_tree)}
  end

  def handle_event("remove_node_from_tree", %{"id" => id}, socket) do
    new_id = get_node_by_id(socket.assigns.node_tree, id).id

    new_tree = NaryTree.delete(socket.assigns.node_tree, new_id)

    {:noreply,
     socket
     |> assign(active_component_id: nil)
     |> assign(node_tree: new_tree)}
  end

  defp map_keys_to_atoms(map) do
    for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}
  end

  # defp map_keys_to_strings(map) do
  #   for {key, val} <- map, into: %{}, do: {Atom.to_string(key), val}
  # end
end
