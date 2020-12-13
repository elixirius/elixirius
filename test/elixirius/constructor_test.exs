defmodule Elixirius.ConstructorTest do
  use Elixirius.DataCase

  import Elixirius.Helpers.FileSystem

  alias Elixirius.Constructor
  alias Elixirius.Constructor.{App, Page, Element}

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
    test "initiate new config skeleton" do
      project_slug = generate_unique_project_slug()
      {:ok, app} = Constructor.init_app(project_slug, "SampleApp")

      assert app == %App{
               id: "SampleApp",
               slug: project_slug,
               constructor_version: Constructor.current_version(),
               deps: %{components: []}
             }

      # Creates json config file
      {:ok, file} = File.read("projects/#{project_slug}/.elixirius/app.json")
      {:ok, json} = Jason.decode(file)

      assert json == %{
               "deps" => %{"components" => []},
               "constructor_version" => Constructor.current_version(),
               "id" => "SampleApp",
               "slug" => project_slug
             }

      # Creates index page json file
      assert File.exists?("projects/#{project_slug}/.elixirius/pages/index.json")
    end

    test "error if project already exist" do
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
      {:ok, app} = Constructor.init_app(project_slug, "SampleApp")
      {:ok, page} = Constructor.add_page(app, "index")

      assert page == %Page{
               id: "index",
               project: project_slug,
               elements: []
             }

      # Creates json config file
      {:ok, file} = File.read("projects/#{project_slug}/.elixirius/pages/index.json")
      {:ok, json} = Jason.decode(file)

      assert json == %{
               "id" => "index",
               "project" => project_slug,
               "elements" => []
             }
    end
  end

  describe "add_element/3" do
    test "add element into page config" do
      project_slug = generate_unique_project_slug()
      {:ok, app} = Constructor.init_app(project_slug, "SampleApp")
      {:ok, page} = Constructor.add_page(app, "index")
      {:ok, page} = Constructor.add_element(page, "Header")

      assert page == %Page{
               id: "index",
               project: project_slug,
               elements: [%Element{type: "Header", id: "header_1", position: 0}]
             }

      # Creates json config file
      {:ok, file} = File.read("projects/#{project_slug}/.elixirius/pages/index.json")
      {:ok, json} = Jason.decode(file)

      assert json == %{
               "id" => "index",
               "project" => project_slug,
               "elements" => [
                 %{
                   "type" => "Header",
                   "id" => "header_1",
                   "data" => %{},
                   "view" => %{},
                   "parent" => nil,
                   "position" => 0
                 }
               ]
             }
    end

    test "add element into position and parent scope" do
      project_slug = generate_unique_project_slug()
      {:ok, app} = Constructor.init_app(project_slug, "SampleApp")
      {:ok, page} = Constructor.add_page(app, "index")
      {:ok, page} = Constructor.add_element(page, "Box")
      {:ok, page} = Constructor.add_element(page, "Box")

      assert page.elements == [
               %Element{type: "Box", id: "box_1", position: 0},
               %Element{type: "Box", id: "box_2", position: 1}
             ]

      {:ok, page} = Constructor.add_element(page, "Box", %{position: 5})

      assert page.elements == [
               %Element{type: "Box", id: "box_1", position: 0},
               %Element{type: "Box", id: "box_2", position: 1},
               %Element{type: "Box", id: "box_3", position: 2}
             ]

      {:ok, page} = Constructor.add_element(page, "Box", %{position: 1})

      assert page.elements == [
               %Element{type: "Box", id: "box_1", position: 0},
               %Element{type: "Box", id: "box_4", position: 1},
               %Element{type: "Box", id: "box_2", position: 2},
               %Element{type: "Box", id: "box_3", position: 3}
             ]

      {:ok, page} = Constructor.add_element(page, "Box", %{parent: "box_1"})

      assert page.elements == [
               %Element{type: "Box", id: "box_1", position: 0},
               %Element{type: "Box", id: "box_4", position: 1},
               %Element{type: "Box", id: "box_2", position: 2},
               %Element{type: "Box", id: "box_3", position: 3},
               %Element{type: "Box", id: "box_5", position: 0, parent: "box_1"}
             ]

      {:ok, page} = Constructor.add_element(page, "Box", %{parent: "box_1"})

      assert page.elements == [
               %Element{type: "Box", id: "box_1", position: 0},
               %Element{type: "Box", id: "box_4", position: 1},
               %Element{type: "Box", id: "box_2", position: 2},
               %Element{type: "Box", id: "box_3", position: 3},
               %Element{type: "Box", id: "box_5", position: 0, parent: "box_1"},
               %Element{type: "Box", id: "box_6", position: 1, parent: "box_1"}
             ]

      {:ok, page} = Constructor.add_element(page, "Box", %{parent: "box_1", position: 1})

      assert page.elements == [
               %Element{type: "Box", id: "box_1", position: 0},
               %Element{type: "Box", id: "box_4", position: 1},
               %Element{type: "Box", id: "box_2", position: 2},
               %Element{type: "Box", id: "box_3", position: 3},
               %Element{type: "Box", id: "box_5", position: 0, parent: "box_1"},
               %Element{type: "Box", id: "box_7", position: 1, parent: "box_1"},
               %Element{type: "Box", id: "box_6", position: 2, parent: "box_1"}
             ]
    end
  end

  describe "update_element/3" do
    test "update existing element on the page" do
      project_slug = generate_unique_project_slug()
      {:ok, app} = Constructor.init_app(project_slug, "SampleApp")
      {:ok, page} = Constructor.add_page(app, "index")
      {:ok, page} = Constructor.add_element(page, "Box")
      {:ok, page} = Constructor.add_element(page, "Box")

      {:ok, page} = Constructor.update_element(page, "box_1", %{id: "parent_box"})

      {:ok, page} =
        Constructor.update_element(page, "box_2", %{id: "child_box", parent: "parent_box"})

      assert page.elements == [
               %Element{type: "Box", id: "parent_box", position: 0, parent: nil},
               %Element{type: "Box", id: "child_box", position: 0, parent: "parent_box"}
             ]
    end

    test "element does not exist" do
      project_slug = generate_unique_project_slug()
      {:ok, app} = Constructor.init_app(project_slug, "SampleApp")
      {:ok, page} = Constructor.add_page(app, "index")
      {:ok, page} = Constructor.add_element(page, "Box")
      {:ok, page} = Constructor.add_element(page, "Box")

      {:error, msg} = Constructor.update_element(page, "box_3", %{id: "box_1"})
      assert msg == :not_exists
    end

    test "must has valid opts" do
      project_slug = generate_unique_project_slug()
      {:ok, app} = Constructor.init_app(project_slug, "SampleApp")
      {:ok, page} = Constructor.add_page(app, "index")
      {:ok, page} = Constructor.add_element(page, "Box")

      {:error, msg} = Constructor.update_element(page, "box_1", %{id: nil, type: nil})

      assert msg == [
               {:error, :id, :presence, "must be present"},
               {:error, :type, :presence, "must be present"}
             ]
    end

    test "must has unique name" do
      project_slug = generate_unique_project_slug()
      {:ok, app} = Constructor.init_app(project_slug, "SampleApp")
      {:ok, page} = Constructor.add_page(app, "index")
      {:ok, page} = Constructor.add_element(page, "Box")
      {:ok, page} = Constructor.add_element(page, "Box")

      {:error, msg} = Constructor.update_element(page, "box_2", %{id: "box_1"})
      assert msg == [{:error, :id, :uniquness, "must be unique"}]
    end

    test "must has existing parent" do
      project_slug = generate_unique_project_slug()
      {:ok, app} = Constructor.init_app(project_slug, "SampleApp")
      {:ok, page} = Constructor.add_page(app, "index")
      {:ok, page} = Constructor.add_element(page, "Box")

      {:error, msg} = Constructor.update_element(page, "box_1", %{parent: "parent_box"})
      assert msg == [{:error, :parent, :exists,  "must exists"}]
    end
  end
end
