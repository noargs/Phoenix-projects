defmodule PlateSlateWeb.Schema do
  use Absinthe.Schema
  alias PlateSlateWeb.Resolvers

  @desc "The list of available items on the menu"
  query do
    # list_of() is a handy macro by Absinthe
    # its shorthand for
    #     %Absinthe.Type.List{of_type: :menu_item}
    field :menu_items, list_of(:menu_item) do
      arg :matching, :string
      resolve &Resolvers.Menu.menu_items/3
    end
  end

  object :menu_item do
    field :id, :id
    field :name, :string
    field :description, :string
  end

#  resolve fn _, %{matching: name}, _ when is_binary(name) ->
#    query = from t in Menu.Item, where: ilike(t.name, ^"%#{name}%")
#    {:ok, Repo.all(query)}
#    _, _, _ ->
#      {:ok, Repo.all(Menu.Item)}
#  end
end
