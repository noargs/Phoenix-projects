defmodule ShopWeb.ProductController do
  use ShopWeb, :controller

  alias Shop.Products

  # @products [
  #   %{id: "1", name: "Street Fighter"},
  #   %{id: "2", name: "Skyrim"},
  #   %{id: "3", name: "Diablo 4"}
  # ]

  @spec index(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def index(conn, _params) do
    products = Products.list_products()

    conn
    # |> assign(:products, @products)
    |> assign(:products, products)
    |> render(:index)
  end

  def show(conn, %{"slug" => slug}) do
    # product = Enum.find(@products, fn product -> product.id == id end)

    product = Products.find_product_by(slug)

    conn
    |> assign(:product, product)
    |> render(:show)
  end

end
