defmodule EctoAssoc.Accounts.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "profiles" do
    field :bio, :string

    belongs_to :user, EctoAssoc.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:bio, :user_id])
    |> validate_required([:bio, :user_id])
    |> assoc_constraint(:user)
  end
end
