defmodule Elixirius.Constructor.Element do
  @moduledoc false

  @derive Jason.Encoder
  @enforce_keys [:type, :id]

  defstruct type: nil, id: nil, parent: nil, position: nil, data: %{}, view: %{}
  use Vex.Struct

  validates(:type, presence: true)
  validates(:id, presence: true)

  def new(type, id, opts \\ %{}) do
    parent = opts[:parent]
    position = opts[:position]

    {:ok, %__MODULE__{type: type, id: id, parent: parent, position: position}}
  end

  def validate(%__MODULE__{} = element, opts \\ %{}) do
    element
    |> Map.merge(opts)
    |> Vex.validate()
    |> case do
      {:ok, _elem} -> {:ok, opts}
      error -> error
    end
  end
end
