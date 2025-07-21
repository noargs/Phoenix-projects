defmodule EctoAssoc.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :title, :string
    field :body, :string

    belongs_to :user, EctoAssoc.Accounts.User
    has_many :comments, EctoAssoc.Blog.Comment
    many_to_many :tags, EctoAssoc.Blog.Tag, join_through: "posts_tags"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :user_id])
    |> validate_required([:title, :body, :user_id])
    |> assoc_constraint(:user)
  end
end
