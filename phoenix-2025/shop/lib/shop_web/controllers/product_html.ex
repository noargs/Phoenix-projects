defmodule ShopWeb.ProductHTML do
  use ShopWeb, :html

  embed_templates "product_html/*"

  # def index(assigns) do
  #   ~H"""
  #   <h1> This is the product listing page </h1>
  #   """
  # end

  attr :name, :string, required: true
  def product(assigns) do  # you can use `{}` instead of `<%= %>` with release of LiveView 1.0
  # you can use `assigns.name` or `@name`
    ~H"""
    <p>Game: <%= assigns.name %></p>
    """
  end
end
