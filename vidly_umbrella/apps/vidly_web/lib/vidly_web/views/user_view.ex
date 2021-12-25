defmodule VidlyWeb.UserView do
  use VidlyWeb, :view

  alias Vidly.Accounts

  def first_name(%Accounts.User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, username: user.username}
  end

end
