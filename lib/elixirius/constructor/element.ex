defmodule Elixirius.Constructor.Element do
  @moduledoc false

  @derive Jason.Encoder
  @enforce_keys [:type, :id]

  defstruct type: nil, id: nil, parent: nil, position: nil, data: %{}, view: %{}

  def new(type, id, opts \\ %{}) do
    parent = opts[:parent]
    position = opts[:position]

    {:ok, %__MODULE__{type: type, id: id, parent: parent, position: position}}
  end
end
