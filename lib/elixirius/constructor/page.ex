defmodule Elixirius.Constructor.Page do
  @moduledoc false
  @derive Jason.Encoder
  @enforce_keys [:project, :name]

  defstruct project: nil, name: nil, elements: []

  def new(project_slug, page_name, attrs \\ %{}) do
    page =
      %__MODULE__{
        project: project_slug,
        name: page_name
      }
      |> Map.merge(attrs)

    {:ok, page}
  end

  def add_element(%__MODULE__{} = page, element) do
    page.elements
    |> Enum.any?(&(&1.name == element.name))
    |> case do
      true -> {:error, :already_exists}
      false -> {:ok, Map.merge(page, %{elements: [element | page.elements]})}
    end
  end
end
