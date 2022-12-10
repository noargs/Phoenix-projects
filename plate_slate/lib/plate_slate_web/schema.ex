defmodule PlateSlateWeb.Schema do
  use Absinthe.Schema
  alias PlateSlate.{Menu, Repo}
  alias PlateSlateWeb.Resolvers

  import Ecto.Query

  query do
    @desc "The list of available items on the menu"
    # list_of() is a handy macro by Absinthe
    # its shorthand for
    #     %Absinthe.Type.List{of_type: :menu_item}
    field :menu_items, list_of(:menu_item) do
#      arg :matching, :string
      arg :filter, :menu_item_filter
      arg :order, :sort_order, default_value: :asc # OR arg :order, :sort_order
      resolve(&Resolvers.Menu.menu_items/3)
    end
  end

  object :menu_item do
    field :id, :id
    field :name, :string
    field :description, :string
    field :added_on, :date
  end

  enum :sort_order do
    value :asc
    value :desc
  end

  scalar :date do
    parse fn input ->
    # <<Parsing logic here>>
    # convert a value from the user to an Elixir term (or returns :error)
    with %Absinthe.Blueprint.Input.String{value: value} <- input,
      {:ok, date} <- Date.from_iso8601(value) do
        {:ok, date}
      else
        _ -> :error
      end
#      case Date.from_iso8601(input.value) do
#        {:ok, date} -> {:ok, date}
#        _ -> :error
#      end
    end
    serialize fn date ->
    # <<Serialization logic here>>
    # converts an Elixir term back into a value to return to user via JSON
      Date.to_iso8601(date)
    end
  end

  # grouping arguments using mechanism calls input object types
  @desc "Filtering options for the menu item list"
  input_object :menu_item_filter do

    @desc "Matching a name"
    field :name, :string

    @desc "Matching a category name"
    field :category, :string

    @desc "Matching a tag"
    field :tag, :string

    @desc "Priced above a value"
    field :priced_above, :float

    @desc "Priced below a value"
    field :priced_below, :float

    @desc "Added to the menu before this date"
    field :added_before, :date

    @desc "Added to the menu after this date"
    field :added_after, :date
  end


#  resolve fn _, %{matching: name}, _ when is_binary(name) ->
#    query = from t in Menu.Item, where: ilike(t.name, ^"%#{name}%")
#    {:ok, Repo.all(query)}
#    _, _, _ ->
#      {:ok, Repo.all(Menu.Item)}
#  end

end
