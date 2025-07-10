defmodule Products.SupplyFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Products.Supply` context.
  """

  @doc """
  Generate a supplier.
  """
  def supplier_fixture(attrs \\ %{}) do
    {:ok, supplier} =
      attrs
      |> Enum.into(%{
        discount: 42,
        name: "some name",
        tin: "some tin"
      })
      |> Products.Supply.create_supplier()

    supplier
  end
end
