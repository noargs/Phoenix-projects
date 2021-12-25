defmodule VidlyWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller

  alias VidlyWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

#  def call(conn, _opts) do
#    user_id = get_session(conn, :user_id)
#    user = user_id && Vidly.Accounts.get_user(user_id)
#    assign(conn, :current_user, user)
#  end

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    cond do
      user = conn.assigns[:current_user] ->
        put_current_user(conn, user)

      user = user_id && Vidly.Accounts.get_user(user_id) ->
        put_current_user(conn, user)

      true ->
        assign(conn, :current_user, nil)
    end
  end

  def login(conn, user) do
    conn
#    |> assign(:current_user, user)
    |> put_current_user(user)
    |> put_session(:user_id, user.id)

    ## "renew: true" tells the Plug to send the session
    ## cookie back to the client with a different identifier
    ## in case attacker knew, by any chance, the previous one
    ## [i.e. to protect from "session fixation attacks"]
    |> configure_session(renew: true)
  end

  def logout(conn) do

    ## if you want to keep the session around but only want to delete the
    ## the user ID then use delete_session(conn, :user_id)
    configure_session(conn, drop: true)
  end

  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "you must be logged in to access that page")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

  defp put_current_user(conn, user) do
    token = Phoenix.Token.sign(conn, "user socket", user.id)

    conn
    |> assign(:current_user, user)
    |> assign(:user_token, token)
  end

end
