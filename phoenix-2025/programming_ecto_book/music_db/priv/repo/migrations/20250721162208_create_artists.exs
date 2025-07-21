defmodule MusicDB.Repo.Migrations.CreateArtists do
  use Ecto.Migration

  def change do
    create table(:artists) do
      add :name, :string
      add :birth_date, :date
      add :death_date, :date

      timestamps()
    end

    create index(:artists, :name)
  end
end
