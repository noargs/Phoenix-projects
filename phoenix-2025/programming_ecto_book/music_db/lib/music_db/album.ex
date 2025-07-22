defmodule MusicDB.Album do
  use Ecto.Schema

  schema "albums" do
    field :title, :string
    timestamps()

    belongs_to :artist, MusicDB.Artist
    has_many :tracks, MusicDB.Track
    many_to_many(:genres, MusicDB.Genre, join_through: "albums_genres")
  end
end
