defmodule MusicDB.Repo.Migrations.CreateLogs do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add :operation, :string
      add :item, :map
      add :changes, :map

      timestamps()
    end
  end
end
