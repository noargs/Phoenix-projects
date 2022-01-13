defmodule Ms.OrderManagementFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ms.OrderManagement` context.
  """

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        creationDate: ~U[2022-01-12 04:35:00Z],
        details: %{},
        message: "some message"
      })
      |> Ms.OrderManagement.create_order()

    order
  end

  @doc """
  Generate a order_item.
  """
  def order_item_fixture(attrs \\ %{}) do
    {:ok, order_item} =
      attrs
      |> Enum.into(%{
        amount: 42,
        unitPrice: 120.5
      })
      |> Ms.OrderManagement.create_order_item()

    order_item
  end
end
