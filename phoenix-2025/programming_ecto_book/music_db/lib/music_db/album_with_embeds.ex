defmodule MusicDB.AlbumWithEmbeds do
  use Ecto.Schema

  schema "albums_with_embeds" do
    field :title, :string
    embeds_one :artist, MusicDB.ArtistEmbed, on_replace: :update
    embeds_many :tracks, MusicDB.TrackEmbed, on_replace: :delete
  end
end
