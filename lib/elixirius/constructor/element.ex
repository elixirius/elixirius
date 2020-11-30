defmodule Elixirius.Constructor.Element do
  @moduledoc false

  @derive Jason.Encoder
  @enforce_keys [:type, :name]

  defstruct type: nil, name: nil, parent: nil, data: %{}, view: %{}

  def new(type, name) do
    {:ok, %__MODULE__{type: type, name: name}}
  end
end
