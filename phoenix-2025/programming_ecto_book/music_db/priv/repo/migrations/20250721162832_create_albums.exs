defmodule MusicDB.Repo.Migrations.CreateAlbums do
  use Ecto.Migration

  def change do
    create table(:albums) do
      add :title, :string
      add :artist_id, references(:artists, on_delete: :nothing)
      timestamps()
    end

    create index(:albums, [:artist_id])
  end
end
