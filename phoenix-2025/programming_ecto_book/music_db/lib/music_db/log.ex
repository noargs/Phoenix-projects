defmodule MusicDB.Log do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset

  schema "logs" do
    field :item, :map
    field :operation, :string
    field :changes, :map

    timestamps()
  end

  def changeset_for_insert(%Changeset{} = changeset) do
    change(%MusicDB.Log{operation: "insert", item: serialize_schema(changeset.data)})
  end

  def changeset_for_insert(%{__meta__: %Ecto.Schema.Metadata{}} = item) do
    change(%MusicDB.Log{operation: "insert", item: serialize_schema(item)})
  end

  def changeset_for_insert(_other) do
    raise "changeset_for_insert can only accept a schema struct or a changeset"
  end

  defp serialize_schema(schema) do
    schema.__struct__.__schema__(:fields)
    |> Enum.reduce(%{}, fn field, acc ->
      Map.put(acc, field, Map.get(schema, field))
    end)
  end
end
