defmodule EctoAssoc.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EctoAssoc.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        name: "some name"
      })
      |> EctoAssoc.Accounts.create_user()

    user
  end

  @doc """
  Generate a profile.
  """
  def profile_fixture(attrs \\ %{}) do
    {:ok, profile} =
      attrs
      |> Enum.into(%{
        bio: "some bio"
      })
      |> EctoAssoc.Accounts.create_profile()

    profile
  end
end
