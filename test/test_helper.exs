ExUnit.configure(timeout: :infinity)
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Elixirius.Repo, :manual)
