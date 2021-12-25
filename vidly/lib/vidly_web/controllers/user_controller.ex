defmodule VidlyWeb.UserController do
  use VidlyWeb, :controller

  alias Vidly.Accounts
  alias Vidly.Accounts.User

  ## plug pipeline in controller explicitly check %PlugConn{halted: true}
  ## so we dont have to do anything like what we did in "index" function below
  ## in comments
  ## [ref: page 92 programming phoenix 1.4]
  plug :authenticate_user when action in [:index, :show]

  def index(conn, _params) do
#    case authenticate(conn) do
#      %PlugConn{halted: true} = conn ->
#        conn
#      conn ->
#        users = Accounts.list_users()
#        render(conn, "index.html", users: users)
#    end
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user(id)
    render(conn, "show.html", user: user)
  end

  # Route /users/new :GET
  # form with "create user" submit button to add "name" and "username"
  def new(conn, _params) do
#    changeset = Accounts.change_user(%User{})
    changeset = Accounts.change_registration(%User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  # Route /users/create :POST
  # if user created then redirect to index page [Route /users]
  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        conn
        |> VidlyWeb.Auth.login(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: Routes.user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

#  ## moved to VidlyWeb.Auth to share across different controllers and router
#  ## then imported in VidlyWeb [lib/vidly_web.ex]
#  defp authenticate(conn, _opts) do
#    if conn.assigns.current_user do
#      conn
#    else
#      conn
#      |> put_flash(:error, "You must be logged in to access that page")
#      |> redirect(to: Routes.page_path(conn, :index))
#      |> halt()
#    end
#  end



end
