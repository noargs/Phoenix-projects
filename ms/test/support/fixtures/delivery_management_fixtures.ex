defmodule Ms.DeliveryManagementFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ms.DeliveryManagement` context.
  """

  @doc """
  Generate a delivery.
  """
  def delivery_fixture(attrs \\ %{}) do
    {:ok, delivery} =
      attrs
      |> Enum.into(%{
        address: %{},
        details: %{},
        fare: 120.5
      })
      |> Ms.DeliveryManagement.create_delivery()

    delivery
  end
end
