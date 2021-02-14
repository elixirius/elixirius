defmodule Elixirius.Constructor.Tree do
  alias Elixirius.Constructor.Page

  def build(%Page{} = _page) do
    home_page =
      NaryTree.Node.new("Page", %{
        id: UUID.uuid1(),
        position: 0,
        title: "Home Page"
      })

    node_1 =
      NaryTree.Node.new("Node", %{
        id: UUID.uuid1(),
        position: 0,
        element: "Card",
        page_id: home_page.content.id,
        attr: %{
          title: "Card Title 1",
          default: "test 1"
        }
      })

    node_2 =
      NaryTree.Node.new("Node", %{
        id: UUID.uuid1(),
        position: 1,
        element: "Card",
        page_id: home_page.content.id,
        attr: %{
          title: "Card Title 2",
          default: "test 2"
        }
      })

    node_3 =
      NaryTree.Node.new("Node", %{
        id: UUID.uuid1(),
        position: 1,
        element: "Card",
        page_id: home_page.content.id,
        attr: %{
          title: "Card Title 3",
          default: "test 3"
        }
      })

    root =
      NaryTree.new(NaryTree.Node.new("Root", %{id: UUID.uuid1()}))
      |> NaryTree.add_child(home_page)
      |> NaryTree.add_child(node_1, home_page.id)
      |> NaryTree.add_child(node_2, home_page.id)
      |> NaryTree.add_child(node_3, node_2.id)

    root
  end

  def get_pages(state) do
    Enum.filter(state, fn node -> node.name == "Page" end)
  end

  def get_page_nodes(state, page_id) do
    Enum.filter(state, fn node ->
      Map.has_key?(node.content, :page_id) && node.content.page_id == page_id
    end)
  end

  def get_default_page_id(state) do
    first_page = state |> get_pages() |> List.first()
    first_page.content.id
  end

  def get_default_page_nodes(state) do
    get_page_nodes(state, get_default_page_id(state))
  end

  def get_node_by_id(state, node_id) do
    Enum.find(state, fn node -> node.content.id == node_id end)
  end

  defp get_attr(attr), do: Map.merge(attr, %{__surface__: %{provided_templates: []}})

  def get_element(state, node_id) do
    get_node_by_id(state, node_id).content.element
  end

  def get_node_attr(state, node) do
    new_node = get_node_by_id(state, node)
    get_attr(new_node.content.attr)
  end

  def get_children(node, state) do
    requested_node = get_node_by_id(state, node)
    children = NaryTree.children(requested_node, state)
    children
  end

  def append_node(state, element) do
    module = Module.concat(["ElixiriusParts", element])

    attr = Map.new(Surface.default_props(module))

    node =
      NaryTree.Node.new("Node", %{
        id: UUID.uuid1(),
        position: 0,
        element: element,
        attr: attr
      })

    parent_uuid = get_default_page_id(state)
    parent_node = get_node_by_id(state, parent_uuid)
    parent_id = parent_node.id

    new_tree = NaryTree.add_child(state, node, parent_id)
    new_tree
  end
end
