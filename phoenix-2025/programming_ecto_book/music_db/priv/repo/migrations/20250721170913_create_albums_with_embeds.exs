defmodule MusicDB.Repo.Migrations.CreateAlbumsWithEmbeds do
  use Ecto.Migration

  def change do
    create table("albums_with_embeds") do
      add :title, :string

      if MusicDB.Repo.using_postgres? do
        add :artist, :jsonb
        add :tracks, {:array, :jsonb}, default: []
      end
    end
  end
end
