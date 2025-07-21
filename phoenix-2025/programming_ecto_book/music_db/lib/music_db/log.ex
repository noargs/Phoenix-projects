defmodule MusicDB.Log do
  use Ecto.Schema

  schema "logs" do
    field :item, :map
    field :operation, :string
    field :changes, :map

    timestamps()
  end
end
