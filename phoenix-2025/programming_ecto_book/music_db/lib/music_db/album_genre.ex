defmodule MusicDB.AlbumGenre do
  use Ecto.Schema

  schema "albums_genres" do
    belongs_to :albums, MusicDB.Album
    belongs_to :genres, MusicDB.Genre
  end

end
