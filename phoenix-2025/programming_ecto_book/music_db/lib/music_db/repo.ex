defmodule MusicDB.Repo do
  use Ecto.Repo,
    otp_app: :music_db,
    adapter: Ecto.Adapters.Postgres

  def using_postgres? do
    MusicDB.Repo.__adapter__ == Ecto.Adapters.Postgres
  end

  # modifing the repo module
  def count(table), do: aggregate(table, :count, :id)

  def avg(table), do: aggregate(table, :avg, :id)

  def min(table), do: aggregate(table, :min, :id)

  def max(table), do: aggregate(table, :max, :id)

  def sum(table), do: aggregate(table, :sum, :id)
end
