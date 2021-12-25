defmodule Vidly.Accounts do
  @moduledoc """
  The Accounts context.
"""
  alias Vidly.Repo
  alias Vidly.Accounts.User
  import Ecto.Query

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  def list_users do
    Repo.all(User)
  end

#  def change_user(%User{} = user) do
#    User.changeset(user, %{})
#  end

  def list_users_with_ids(ids) do
    Repo.all(from(u in User, where: u.id in ^ids))
  end

  def change_registration(%User{} = user, params) do
    User.registration_changeset(user, params)
  end

  ## create new user, meant to be used for end user
  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  ## create new user for "internal uses" without full ceremony
  ## [i.e. seeding example data, imports, or sending user invitations]
  ## not meant to be used for end users
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def authenticate_by_username_pass(username, given_pass) do
    user = get_user_by(username: username)

    cond do
      user && Pbkdf2.verify_pass(given_pass, user.password_hash) ->
        {:ok, user}
      user ->
        {:error, :unauthorized}
      true ->
        ## "no_user_verify()" of comeonin function simulate password check
        ## in varaible timings
        Pbkdf2.no_user_verify()
        {:error, :not_found}
    end
  end


#  def list_users do
#    [
#      %User{id: "1", name: "Jose", username: "josevalim"},
#      %User{id: "2", name: "Bruce", username: "redrapids"},
#      %User{id: "3", name: "Chris", username: "chrismccord"}
#    ]
#  end
#
#  def get_user(id) do
#    Enum.find(list_users(), fn map -> map.id == id  end)
#  end
#
#  def get_user_by(params) do
#    Enum.find(list_users(), fn map ->
#      Enum.all?(params, fn {key, val} -> Map.get(map, key) == val end)
#    end)
#  end

end
