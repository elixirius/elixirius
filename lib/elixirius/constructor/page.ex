defmodule Elixirius.Constructor.Page do
  @moduledoc false
  @derive Jason.Encoder

  defstruct project: nil, name: nil, path: nil, url: nil

  def new(project_slug, page_name, attrs \\ %{}) do
    page =
      %__MODULE__{
        project: project_slug,
        name: page_name,
        url: "/",
        path: build_page_path(project_slug, page_name)
      }
      |> Map.merge(attrs)

    {:ok, page}
  end

  def save(%__MODULE__{} = page) do
    File.mkdir_p!(Path.dirname(page.path))

    page.path
    |> File.write(Jason.encode!(page, pretty: true), [:binary])
    |> case do
      :ok -> {:ok, page}
      error -> error
    end
  end

  @path_delim "/"

  def build_page_path(project_slug, page_name) do
    Enum.join(["projects", project_slug, ".elixirius", "pages", "#{page_name}.json"], @path_delim)
  end
end
