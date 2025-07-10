defmodule ProductsWeb.SupplierController do
  use ProductsWeb, :controller

  alias Products.Supply
  alias Products.Supply.Supplier

  action_fallback ProductsWeb.FallbackController

  def index(conn, _params) do
    suppliers = Supply.list_suppliers()
    render(conn, :index, suppliers: suppliers)
  end

  def create(conn, %{"supplier" => supplier_params}) do
    with {:ok, %Supplier{} = supplier} <- Supply.create_supplier(supplier_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/suppliers/#{supplier}")
      |> render(:show, supplier: supplier)
    end
  end

  def show(conn, %{"id" => id}) do
    supplier = Supply.get_supplier!(id)
    render(conn, :show, supplier: supplier)
  end

  def update(conn, %{"id" => id, "supplier" => supplier_params}) do
    supplier = Supply.get_supplier!(id)

    with {:ok, %Supplier{} = supplier} <- Supply.update_supplier(supplier, supplier_params) do
      render(conn, :show, supplier: supplier)
    end
  end

  def delete(conn, %{"id" => id}) do
    supplier = Supply.get_supplier!(id)

    with {:ok, %Supplier{}} <- Supply.delete_supplier(supplier) do
      send_resp(conn, :no_content, "")
    end
  end
end
