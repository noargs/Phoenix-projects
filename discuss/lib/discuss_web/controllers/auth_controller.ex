defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  plug Ueberauth

  alias Discuss.Accounts
  alias Discuss.Accounts.User

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, %{"provider" => provider}) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: provider}

    signin(conn, user_params)

#    IO.puts "++++++++++++++++++++"
#    IO.inspect(conn.assigns)
#    IO.puts "++++++++++++++++++++"
#    IO.inspect(params)
#    IO.puts "++++++++++++++++++++"

  end

  defp signin(conn, changeset) do
    case Accounts.authenticate_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: Routes.topic_path(conn, :index))
    end
  end

end
