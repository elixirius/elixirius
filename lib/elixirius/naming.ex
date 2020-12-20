defmodule Elixirius.Naming do
  def undersorize(str) when is_binary(str) do
    str
    |> String.replace(" ", "_")
    |> String.downcase()
  end

  def modulize(str) when is_binary(str) do
    str
    |> String.split(" ")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join()
  end
end
