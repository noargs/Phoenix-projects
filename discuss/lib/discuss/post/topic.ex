defmodule Discuss.Post.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :title, :string

    timestamps()
  end

  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end

end
