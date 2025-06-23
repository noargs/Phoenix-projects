defmodule ShopWeb.ProductHTML do
  use ShopWeb, :html

  embed_templates "product_html/*"

  # def index(assigns) do
  #   ~H"""
  #   <h1> This is the product listing page </h1>
  #   """
  # end
end
