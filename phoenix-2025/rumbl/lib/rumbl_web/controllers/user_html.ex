defmodule RumblWeb.UserHTML do
  use RumblWeb, :html

  alias Rumbl.Accounts

  embed_templates "user_html/*"

  def first_name(%Accounts.User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end

  attr :user, Accounts.User, required: true
  def user(assigns) do
    ~H"""
    <b><%= first_name(@user) %></b> (<%= @user.id %>)
    """
  end

  @doc """
  Renders a user form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def user_form(assigns)
end
