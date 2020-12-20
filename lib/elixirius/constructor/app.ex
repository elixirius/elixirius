defmodule Elixirius.Constructor.App do
  @moduledoc false

  @derive Jason.Encoder
  @enforce_keys [:id, :name]

  defstruct id: nil,
            name: nil,
            constructor_version: "",
            deps: %{components: []}

  def new(id, name, attrs \\ %{}) do
    app =
      %__MODULE__{
        id: id,
        name: name
      }
      |> Map.merge(attrs)

    {:ok, app}
  end
end
