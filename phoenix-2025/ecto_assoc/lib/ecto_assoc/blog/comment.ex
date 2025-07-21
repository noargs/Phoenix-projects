defmodule EctoAssoc.Blog.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string

    belongs_to :post, EctoAssoc.Blog.Post

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :post_id])
    |> validate_required([:body, :post_id])
    |> assoc_constraint(:post)
  end
end
