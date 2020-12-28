defmodule Elixirius.NamingTest do
  @moduledoc false

  use Elixirius.DataCase

  alias Elixirius.Naming

  describe "undersorize/1" do
    test "returns string as user_score_name" do
      assert Naming.undersorize("my app") == "my_app"
      assert Naming.undersorize("My App") == "my_app"
      assert Naming.undersorize("MyApp") == "myapp"
      assert Naming.undersorize("Myapp") == "myapp"
    end
  end

  describe "modulize/1" do
    test "returns string as ModuleName" do
      assert Naming.modulize("my app") == "MyApp"
      assert Naming.modulize("My App") == "MyApp"
      assert Naming.modulize("MyApp") == "Myapp"
      assert Naming.modulize("myApp") == "Myapp"
    end
  end
end
