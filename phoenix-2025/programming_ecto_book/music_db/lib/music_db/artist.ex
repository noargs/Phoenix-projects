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

  def changeset(%MusicDB.Band{} = band) do
    {:ok, birth_date} = Date.new(band.year_started, 1, 1)
    {:ok, death_date} = Date.new(band.year_ended, 12, 31)

    changeset(%MusicDB.Artist{
      name: band.name,
      birth_date: birth_date,
      death_date: death_date
    }, %{})
  end

  def changeset(%MusicDB.SoloArtist{} = solo_artist) do
    name =
      "#{solo_artist.name1} #{solo_artist.name2} #{solo_artist.name3}"
      |> String.trim()

    changeset(%MusicDB.Artist{
      name: name,
      birth_date: solo_artist.birth_date,
      death_date: solo_artist.death_date
    }, %{})
  end
end
