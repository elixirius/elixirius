defmodule Elixirius.Constructor.Page do
  @moduledoc false

  import Phoenix.Naming, only: [underscore: 1]
  alias Elixirius.Constructor.Element

  @derive Jason.Encoder
  @enforce_keys [:project, :id]

  defstruct project: nil, id: nil, elements: []

  def new(project_id, page_id, attrs \\ %{}) do
    %__MODULE__{
      project: project_id,
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
    |> any_element_by?(:id, id_candidate)
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

  def get_element(%__MODULE__{} = page, elem_id) do
    page.elements
    |> Enum.find(&(&1.id == elem_id))
    |> case do
      nil -> {:error, :not_exists}
      elem -> {:ok, elem}
    end
  end

  def update_element(%__MODULE__{} = page, %Element{} = old_element, opts \\ %{}) do
    new_element = Map.merge(old_element, opts)

    page
    |> unassign_element(old_element)
    |> assign_element(new_element)
    |> update_childred(old_element.id == new_element.id, old_element, new_element)
    |> reorder_elements()
    |> success()
  end

  defp update_childred(page, true, _old_el, _new_el), do: page

  defp update_childred(page, false, old_el, new_el) do
    updated_elements =
      Enum.map(page.elements, fn el ->
        if el.parent == old_el.id do
          Map.put(el, :parent, new_el.id)
        else
          el
        end
      end)

    Map.put(page, :elements, updated_elements)
  end

  def validate_element_id(%__MODULE__{} = page, nil), do: {:ok, page}

  def validate_element_id(%__MODULE__{} = page, elem_id) do
    page.elements
    |> any_element_by?(:id, elem_id)
    |> case do
      true -> {:error, [{:error, :id, :uniquness, "must be unique"}]}
      false -> {:ok, page}
    end
  end

  def validate_element_parent(%__MODULE__{} = page, nil), do: {:ok, page}

  def validate_element_parent(%__MODULE__{} = page, parent) do
    page.elements
    |> any_element_by?(:id, parent)
    |> case do
      true -> {:ok, page}
      false -> {:error, [{:error, :parent, :exists, "must exists"}]}
    end
  end

  defp any_element_by?(elements_list, key, value) do
    Enum.any?(elements_list, &(Map.get(&1, key) == value))
  end

  defp assign_element(page, element) do
    position = define_element_position(page.elements, element)
    new_elem = Map.put(element, :position, position)
    Map.put(page, :elements, [new_elem | page.elements])
  end

  def remove_element(%__MODULE__{} = page, %Element{} = element) do
    page
    |> unassign_element(element)
    |> remove_children(element)
    |> reorder_elements()
    |> success()
  end

  defp remove_children(page, element) do
    related_sublings = find_sublings(page, element)
    new_elements = Enum.reject(page.elements, &Enum.member?(related_sublings, &1))

    Map.put(page, :elements, new_elements)
  end

  defp find_sublings(page, el) do
    children = filter_elements_by_parent(page.elements, el)

    find_sublings(page, el, children, children)
  end

  defp find_sublings(page, _el, [head | tail], acum) do
    children = filter_elements_by_parent(page.elements, head)

    find_sublings(page, head, tail ++ children, acum ++ children)
  end

  defp find_sublings(_page, _el, [], acum) do
    acum
  end

  defp filter_elements_by_parent(elements_list, parent_elem) do
    Enum.filter(elements_list, &(&1.parent == parent_elem.id))
  end

  defp unassign_element(page, element) do
    Map.put(page, :elements, Enum.reject(page.elements, &(&1.id == element.id)))
  end

  defp define_element_position(elements_list, element) do
    scoped_elements = Enum.filter(elements_list, &(&1.parent == element.parent))
    scoped_amount = Enum.count(scoped_elements) + 1

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
          Map.put(elem, :position, idx + 1)
        end)
      end)

    Map.put(page, :elements, ordered_elements)
  end

  defp success(value), do: {:ok, value}
end
