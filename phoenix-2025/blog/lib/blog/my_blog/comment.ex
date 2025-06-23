defmodule Blog.MyBlog.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    field :commenter, :string
    belongs_to :article, Blog.MyBlog.Article

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:commenter, :body, :article_id])
    |> validate_required([:commenter, :body])
    |> assoc_constraint(:article)
  end
end
