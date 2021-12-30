defmodule Discuss.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :provider, :string
    field :token, :string

    timestamps()
  end

  def changeset(user, attr) do
    user
    |> cast(attr, [:email, :provider, :token])
    |> validate_required([:email, :provider, :token])
    |> unique_constraint(:email)
  end

#  def fetch_change(changeset, key) do
#    Changeset.fetch_change(changeset, key)
#  end



end
