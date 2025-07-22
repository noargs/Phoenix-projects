defmodule MusicDB.Track do
  use Ecto.Schema

  schema "tracks" do
    field :index, :integer
    field :title, :string
    field :duration, :integer
    field :number_of_plays, :integer
    timestamps()

    belongs_to :album, MusicDB.Album
    field :duration_string, :string, virtual: true

  end

end
