defmodule Elixirius.Template do
  @moduledoc """
  Generate a new project with given template
  """

  alias Elixirius.{Constructor, Naming}

  # TODO: Create template instance with config
  @default_template "phoenix_live_no_db_v1"
  @module_name "SampleApp"
  @underscore_name "sample_app"
  @projects_dir "projects"

  def seed_project(project_id, project_name) do
    module_name = Naming.modulize(project_name)
    underscore_name = Naming.undersorize(project_name)

    with true <- prepare_directory(project_id),
         true <- copy_template(project_id),
         true <- rename_core_dirs_and_files(project_id, underscore_name),
         true <- find_and_replace(project_id, @module_name, module_name),
         true <- find_and_replace(project_id, @underscore_name, underscore_name),
         {:ok, app} <- Constructor.init_app(project_id, project_name),
         {:ok, _page} <- Constructor.add_page(app, "index") do
      true
    else
      error -> IO.inspect(error, label: "Failed to seed new project #{project_id}")
    end
  end

  defp prepare_directory(_project_id) do
    File.mkdir_p(@projects_dir)

    true
  end

  defp copy_template(project_id) do
    System.cmd("cp", ["-a", "templates/#{@default_template}", "projects/#{project_id}"])
    |> case do
      {"", 0} -> true
      error -> error
    end
  end

  defp rename_core_dirs_and_files(project_id, underscore_name) do
    System.cmd("mv", [
      "projects/#{project_id}/lib/sample_app",
      "projects/#{project_id}/lib/#{underscore_name}"
    ])

    System.cmd("mv", [
      "projects/#{project_id}/lib/sample_app_web",
      "projects/#{project_id}/lib/#{underscore_name}_web"
    ])

    System.cmd("mv", [
      "projects/#{project_id}/lib/sample_app.ex",
      "projects/#{project_id}/lib/#{underscore_name}.ex"
    ])

    System.cmd("mv", [
      "projects/#{project_id}/lib/sample_app_web.ex",
      "projects/#{project_id}/lib/#{underscore_name}_web.ex"
    ])

    true
  end

  defp find_and_replace(project_id, left, right) do
    :os.cmd(
      String.to_charlist(
        "grep -rl #{left} projects/#{project_id} | xargs sed -i '' s/#{left}/#{right}/g"
      )
    )

    true
  end
end
