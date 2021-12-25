defmodule Vidly.Repo do
  use Ecto.Repo,
    otp_app: :vidly,
    adapter: Ecto.Adapters.Postgres
end
