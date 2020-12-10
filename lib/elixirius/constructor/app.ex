defmodule Elixirius.Constructor.App do
  @moduledoc false

  @derive Jason.Encoder
  @enforce_keys [:slug, :id]

  defstruct slug: nil,
            id: nil,
            constructor_version: "",
            deps: %{components: []}

  def new(slug, id, attrs \\ %{}) do
    app =
      %__MODULE__{
        slug: slug,
        id: id
      }
      |> Map.merge(attrs)

    {:ok, app}
  end
end
