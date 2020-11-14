defmodule Elixirius.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :elixirius,
    adapter: Ecto.Adapters.Postgres
end
