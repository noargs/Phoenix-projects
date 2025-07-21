defmodule MusicDB.Repo.Migrations.CreateAlbumsGenres do
  use Ecto.Migration

  def change do
    create table :albums_genres do
      add :album_id, references(:albums)
      add :genre_id, references(:genres)
    end

    create unique_index(:albums_genres, [:album_id, :genre_id])
  end
end
