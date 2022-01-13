defmodule Discuss.Accounts do
  @moduledoc """
  Accounts context
  """

  alias Discuss.Repo
  alias Discuss.Accounts.User

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  def authenticate_user(params) do
    %User{}
    |> User.changeset(params)
    |> insert_or_update_user()
  end

  def insert_or_update_user(changeset) do
    case get_user_by(email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end

end
