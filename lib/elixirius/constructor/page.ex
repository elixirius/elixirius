defmodule Elixirius.Constructor.Page do
  @moduledoc false

  import Phoenix.Naming, only: [underscore: 1]

  @derive Jason.Encoder
  @enforce_keys [:project, :id]

  defstruct project: nil, id: nil, elements: []

  def new(project_slug, page_id, attrs \\ %{}) do
    %__MODULE__{
      project: project_slug,
      id: page_id
    }
    |> Map.merge(attrs)
    |> success()
  end

  def generate_element_id(%__MODULE__{} = page, element_type) do
    page.elements
    |> Enum.filter(&(&1.type == element_type))
    |> gen_seq_element_id(underscore(element_type), 1)
    |> success()
  end

  defp gen_seq_element_id(elements, prefix, seq) do
    id_candidate = "#{prefix}_#{seq}"

    elements
    |> any_element_by_id?(id_candidate)
    |> case do
      true -> gen_seq_element_id(elements, prefix, seq + 1)
      false -> id_candidate
    end
  end

  def add_element(%__MODULE__{} = page, element) do
    page
    |> assign_element(element)
    |> reorder_elements()
    |> success()
  end

  defp any_element_by_id?(elements_list, element_id) do
    Enum.any?(elements_list, &(&1.id == element_id))
  end

  defp assign_element(page, element) do
    position = define_element_position(page.elements, element)
    new_elem = Map.put(element, :position, position)
    Map.put(page, :elements, [new_elem | page.elements])
  end

  defp define_element_position(elements_list, element) do
    scoped_elements = Enum.filter(elements_list, &(&1.parent == element.parent))
    scoped_amount = Enum.count(scoped_elements)

    cond do
      element.position == nil -> scoped_amount
      element.position > scoped_amount -> scoped_amount
      true -> element.position
    end
  end

  defp reorder_elements(page) do
    ordered_elements =
      page.elements
      |> Enum.group_by(& &1.parent)
      |> Enum.flat_map(fn {_parent, elements} ->
        elements
        |> Enum.sort_by(& &1.position)
        |> Enum.with_index()
        |> Enum.map(fn {elem, idx} ->
          Map.put(elem, :position, idx)
        end)
      end)

    Map.put(page, :elements, ordered_elements)
  end

  defp success(value), do: {:ok, value}
end
