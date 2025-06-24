defmodule ShopWeb.ProductHTML do
  use ShopWeb, :html

  alias Shop.Products.Product

  embed_templates "product_html/*"

  # def index(assigns) do
  #   ~H"""
  #   <h1> This is the product listing page </h1>
  #   """
  # end

  attr :product, Product, required: true
  def product(assigns) do  # you can use `{}` instead of `<%= %>` with release of LiveView 1.0
  # you can use `assigns.name` or `@name`
    ~H"""
    <%!-- <p>Game: <%= @product.name %></p> --%>
    <.link href={~p"/products/#{@product.slug}"} class="block">{@product.name}</.link>
    """
  end
end
