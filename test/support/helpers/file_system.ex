defmodule Elixirius.Helpers.FileSystem do
  def generate_unique_project_slug, do: "test#{System.unique_integer()}"

  @test "test"
  def clear_test_projects do
    {:ok, base_path} = File.cwd()

    "#{base_path}/projects/*"
    |> Path.wildcard()
    |> Enum.filter(fn dir_name ->
      dir_name
      |> String.split("/")
      |> List.last()
      |> String.starts_with?(@test)
    end)
    |> Enum.map(fn test_dir -> File.rm_rf(test_dir) end)
  end
end
