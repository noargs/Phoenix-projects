defmodule MusicDB.Album do
  use Ecto.Schema

  schema "albums" do
    field :title, :string

    belongs_to :artist, MusicDB.Artist
    has_many :tracks, MusicDB.Track
    timestamps()
  end
end
