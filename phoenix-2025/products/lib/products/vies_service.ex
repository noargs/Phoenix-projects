defmodule Products.ViexService do
  @callback lookup(String.t()) :: %Viex.Response{} | {:error, String.t()}

  def lookup(tin), do: impl().lookup(tin)
  defp impl, do: Application.get_env(:products, :vies_service, Viex)
end
