defmodule Ms.CustomerManagementFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ms.CustomerManagement` context.
  """

  @doc """
  Generate a customer.
  """
  def customer_fixture(attrs \\ %{}) do
    {:ok, customer} =
      attrs
      |> Enum.into(%{
        details: %{},
        name: "some name",
        phone: "some phone",
        pincode: "some pincode"
      })
      |> Ms.CustomerManagement.create_customer()

    customer
  end
end
