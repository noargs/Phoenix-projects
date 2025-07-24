defmodule MusicDB.Track do
  use Ecto.Schema

  schema "tracks" do
    field :title, :string
    field :duration, :integer          # length of track in seconds
    field :index, :integer             # track's position in an album
    field :number_of_plays, :integer   # counter, we increment when play the track
    timestamps()

    belongs_to :album, MusicDB.Album
    field :duration_string, :string, virtual: true

  end

end
