defmodule Elixirius.ConstructorTest do
  use Elixirius.DataCase

  import Elixirius.Helpers.FileSystem

  alias Elixirius.Constructor
  alias Elixirius.Constructor.{App, Page}

  setup do
    clear_test_projects()

    :ok
  end

  describe "current_version/0" do
    test "returns elixirius app version" do
      {:ok, char_version} = :application.get_key(:elixirius, :vsn)
      strign_version = List.to_string(char_version)

      assert Constructor.current_version() == strign_version
    end
  end

  describe "init_app/2" do
    @tag :focus # <====== REMOVE ME!!!
    test "initiate new config skeleton" do
      project_slug = generate_unique_project_slug()
      {:ok, app} = Constructor.init_app(project_slug, "SampleApp")

      assert app == %App{
               name: "SampleApp",
               slug: project_slug,
               workdir_path: "projects/#{project_slug}/.elixirius",
               constructor_version: Constructor.current_version(),
               deps: %{components: []}
             }

      # Creates json config file
      {:ok, file} = File.read("projects/#{project_slug}/.elixirius/app.json")
      {:ok, json} = Jason.decode(file)

      assert json == %{
               "deps" => %{"components" => []},
               "constructor_version" => Constructor.current_version(),
               "name" => "SampleApp",
               "workdir_path" => "projects/#{project_slug}/.elixirius",
               "slug" => project_slug
             }

      # Creates index page json file
      assert File.exists?("projects/#{project_slug}/.elixirius/pages/index.json")
    end

    test "error if project already exists" do
      project_slug = generate_unique_project_slug()
      {:ok, _app} = Constructor.init_app(project_slug, "SampleApp")
      {:error, msg} = Constructor.init_app(project_slug, "SampleApp")

      assert msg == :already_exists
    end
  end

  describe "get_app/1" do
    test "read app config from the file system and returns app struct" do
      project_slug = generate_unique_project_slug()
      {:ok, write_app} = Constructor.init_app(project_slug, "SampleApp")
      {:ok, read_app} = Constructor.get_app(project_slug)

      assert write_app == read_app
    end

    test "returns error for non existing project" do
      {:error, msg} = Constructor.get_app(generate_unique_project_slug())

      assert msg == :not_exists
    end
  end

  describe "add_page/3" do
    test "create page config" do
      project_slug = generate_unique_project_slug()
      {:ok, page} = Constructor.add_page(project_slug, "index")

      assert page == %Page{
               name: "index",
               project: project_slug,
               url: "/",
               path: "projects/#{project_slug}/.elixirius/pages/index.json"
             }

      # Creates json config file
      {:ok, file} = File.read("projects/#{project_slug}/.elixirius/pages/index.json")
      {:ok, json} = Jason.decode(file)

      assert json == %{
               "name" => "index",
               "path" => "projects/#{project_slug}/.elixirius/pages/index.json",
               "project" => project_slug,
               "url" => "/"
             }
    end
  end
end
