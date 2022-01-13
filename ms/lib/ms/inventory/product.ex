defmodule Ms.Inventory.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :price, :float
    field :stock, :integer
    field :tax, :float

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:price, :stock, :name, :tax])
    |> validate_required([:price, :stock, :name, :tax])
  end
end
