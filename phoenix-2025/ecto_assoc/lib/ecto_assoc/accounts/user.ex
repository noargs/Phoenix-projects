defmodule EctoAssoc.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string

    has_one :profile, EctoAssoc.Accounts.Profile
    has_many :posts, EctoAssoc.Blog.Post
    has_many :tags, through: [:posts, :tags]   # `through` association

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
  end
end
