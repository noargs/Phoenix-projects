defmodule ProductsWeb.Plugs.PayloadValidation do
  import Plug.Conn
  use ProductsWeb, :controller

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.method in ["POST", "PUT"] do
      key = conn.path_info |> List.last() |> singularize()

      if Map.has_key?(conn.body_params, key) do
        conn
      else
        conn |> put_status(:bad_request) |> put_view(json: ProductsWeb.ErrorJSON)
        |> render(:"400", error: "Expected the '#{key}' key in the request body")
        |> halt()
      end
      conn
    end
  end

  defp singularize(plural) when is_bitstring(plural) do
    ending = String.slice(plural, -3..-1)

    if ending == "ies" do
      String.replace(plural, ending, "y")
    else
      String.trim_trailing(plural, "s")
    end
  end
end
