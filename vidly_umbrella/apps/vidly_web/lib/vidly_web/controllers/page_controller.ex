defmodule VidlyWeb.PageController do
  use VidlyWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
