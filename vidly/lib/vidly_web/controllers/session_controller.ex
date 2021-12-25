defmodule VidlyWeb.SessionController do
  use VidlyWeb, :controller

  def new(conn, _) do
    render(conn, "new.html")
  end

  # Route /users/create :POST
  # if authenticated and session created then redirect to index page
  def create(conn, %{"session" => %{"username" => username, "password" => pass}}) do
    case Vidly.Accounts.authenticate_by_username_pass(username, pass) do
      {:ok, user} ->
        conn
        |> VidlyWeb.Auth.login(user)
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: Routes.page_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid username/password combination")
        |> render("new.html")
      end
  end

  def delete(conn, _) do
    conn
    |> VidlyWeb.Auth.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end

end

