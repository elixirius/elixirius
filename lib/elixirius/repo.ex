defmodule Elixirius.Repo do
  use Ecto.Repo,
    otp_app: :elixirius,
    adapter: Ecto.Adapters.Postgres
end
