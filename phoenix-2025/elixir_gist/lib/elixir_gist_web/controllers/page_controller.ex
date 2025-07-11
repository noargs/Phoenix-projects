defmodule ElixirGistWeb.PageController do
  use ElixirGistWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    # render(conn, :home, layout: false) # Dont load `app.html.heex` only `home.html.heex`
    # render(conn, :home)
    redirect(conn, to: "/create")
  end
end
