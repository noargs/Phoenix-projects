defmodule MusicDB.Artist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "artists" do
    field :name, :string
    field :birth_date, :date
    field :death_date, :date

    has_many :albums, MusicDB.Album

    timestamps()
  end

  @doc false
  def changeset(artist, attrs) do
    artist
    |> cast(attrs, [:name, :birth_date, :death_date])
    |> validate_required([:name])
  end
end
