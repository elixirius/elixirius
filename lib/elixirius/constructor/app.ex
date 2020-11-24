defmodule Elixirius.Constructor.App do
  @moduledoc false

  @derive Jason.Encoder
  @enforce_keys [:slug, :name]

  defstruct slug: nil,
            name: nil,
            constructor_version: "",
            deps: %{components: []}

  def new(slug, name, attrs \\ %{}) do
    app =
      %__MODULE__{
        slug: slug,
        name: name
      }
      |> Map.merge(attrs)

    {:ok, app}
  end
end
