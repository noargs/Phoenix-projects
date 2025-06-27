defmodule ShopWeb.ProductLive.Index do
  use ShopWeb, :live_view
  alias Shop.Products

  def mount(_params, _session, socket) do
    products = Products.list_products()
    likes =
      products
      |> Enum.map(fn product -> {product.id, 0} end)
      |> Map.new()
    dbg(likes)

    socket =
      socket
      |> assign(:products, products)
      |> assign(:likes, likes)

    {:ok, socket}
  end

  def handle_event("like", _values, socket) do
    {:noreply, socket}
  end

  def handle_event("dislike", _values, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div :for={product <- @products}>
      <p>{product.name} - Likes: {@likes[product.id]}</p>

      <.icon name="hero-hand-thumb-down-mini" class="size-4" phx-click="dislike" />
      <.icon name="hero-hand-thumb-up-mini" class="size-4" phx-click="like" />
    </div>
    """
  end
end
