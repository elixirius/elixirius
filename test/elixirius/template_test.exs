defmodule Elixirius.TemplateTest do
  use Elixirius.DataCase

  import Elixirius.Helpers.FileSystem

  alias Elixirius.Template

  setup do
    clear_test_projects()

    :ok
  end

  describe "seed_project/0" do
    test "returns elixirius app version" do
      project_id = generate_unique_project_id()
      Template.seed_project(project_id, "TestApp")

      # Rename core dirs and files
      assert File.exists?("projects/#{project_id}/lib/testapp.ex")
      assert File.exists?("projects/#{project_id}/lib/testapp_web.ex")
      assert File.exists?("projects/#{project_id}/lib/testapp/application.ex")
      assert File.exists?("projects/#{project_id}/lib/testapp_web/router.ex")

      # Rename SampleApp and sample_app
      {:ok, file} = File.read("projects/#{project_id}/lib/testapp.ex")
      assert String.starts_with?(file, "defmodule Testapp") == true

      {:ok, file} = File.read("projects/#{project_id}/lib/testapp_web.ex")
      assert String.starts_with?(file, "defmodule TestappWeb") == true

      {:ok, file} = File.read("projects/#{project_id}/mix.exs")
      assert file =~ "app: :testapp"

      # Init .elixirius config
      assert File.exists?("projects/#{project_id}/.elixirius/app.json")
      assert File.exists?("projects/#{project_id}/.elixirius/pages/index.json")
    end
  end
end
