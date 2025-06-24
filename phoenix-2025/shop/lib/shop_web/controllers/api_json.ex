defmodule ShopWeb.ApiJSON do

  def index(assigns) do

    # you can also do
    #
    # def index(%{products: products}) do
    #   %{products: products}
    # end

    %{products: assigns.products}
  end

end
