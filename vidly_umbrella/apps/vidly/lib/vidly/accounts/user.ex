defmodule Vidly.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

#  mix ecto.gen.migrate create_users
#   defstruct [:id, :name, :username]

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true # virtual field only exist in struct not in database
    field :password_hash, :string

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username]) # Ecto.Changeset.cast convert raw map of user input to a changeset
    |> validate_required([:name, :username]) # return Ecto.Changeset into "validate_length"
    |> validate_length(:username, min: 1, max: 20)
    |> unique_constraint(:username)
  end

  ## Register new user
  ##  User.registration_changeset(%User{}, %{
  ##    username: "max", name: "Max", password: "123456"
  ##  })
  def registration_changeset(user, params) do
    user
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 50)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))
      _ ->
        changeset
    end
  end

end
