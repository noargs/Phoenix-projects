defmodule EctoAssoc.Blog.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field :name, :string

    many_to_many :posts, EctoAssoc.Blog.Post, join_through: "posts_tags"
    has_many :users, through: [:posts, :user]  # `through` association

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
