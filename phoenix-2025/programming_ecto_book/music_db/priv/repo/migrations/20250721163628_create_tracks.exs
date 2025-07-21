defmodule MusicDB.Repo.Migrations.CreateTracks do
  use Ecto.Migration

  def change do
    create table(:tracks) do
      add :title, :string
      add :duration, :integer
      add :index, :integer
      add :number_of_plays, :integer, default: 0
      add :album_id, references(:albums, on_delete: :nothing)

      timestamps()
    end

    create index(:tracks, [:title, :album_id])
  end
end
