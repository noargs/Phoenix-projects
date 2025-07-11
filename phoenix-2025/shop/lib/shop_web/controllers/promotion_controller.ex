defmodule ShopWeb.PromotionController do
  use ShopWeb, :controller

  alias Shop.Promotions
  alias Shop.Promotions.Promotion

  def index(conn, _params) do
    promotions = Promotions.list_promotions()
    render(conn, :index, promotions: promotions)
  end

  def new(conn, _params) do
    changeset = Promotions.change_promotion(%Promotion{})
    render(conn, :new, changeset: changeset)
  end

  @doc """
  {
    "promotions": {
      "name": "Winter Sale",
      "code": "SNOW35"
    }
  }
  """
  def create(conn, %{"promotion" => promotion_params}) do
    case Promotions.create_promotion(promotion_params) do
      {:ok, promotion} ->
        conn
        |> put_flash(:info, "Promotion created successfully.")
        |> redirect(to: ~p"/promotions/#{promotion}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    promotion = Promotions.get_promotion!(id)
    render(conn, :show, promotion: promotion)
  end

  def edit(conn, %{"id" => id}) do
    promotion = Promotions.get_promotion!(id)
    changeset = Promotions.change_promotion(promotion)
    render(conn, :edit, promotion: promotion, changeset: changeset)
  end

  def update(conn, %{"id" => id, "promotion" => promotion_params}) do
    promotion = Promotions.get_promotion!(id)

    case Promotions.update_promotion(promotion, promotion_params) do
      {:ok, promotion} ->
        conn
        |> put_flash(:info, "Promotion updated successfully.")
        |> redirect(to: ~p"/promotions/#{promotion}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, promotion: promotion, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    promotion = Promotions.get_promotion!(id)
    {:ok, _promotion} = Promotions.delete_promotion(promotion)

    conn
    |> put_flash(:info, "Promotion deleted successfully.")
    |> redirect(to: ~p"/promotions")
  end
end
