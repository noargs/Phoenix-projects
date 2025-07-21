defmodule MusicDB.ArtistEmbed do
  import Ecto.Changeset
  use Ecto.Schema

  embedded_schema() do
    field :name
  end

  def changeset(artist_embed, params) do
    artist_embed
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
