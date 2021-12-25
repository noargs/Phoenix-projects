defmodule VidlyWeb.UserSocket do
  use Phoenix.Socket

  ## Channel
  channel "videos:*", VidlyWeb.VideoChannel

  @max_age 2 * 7 * 24 * 60 * 60


  @doc """
  The connect function decides whether to make
  a connection.

  It receives the connection parameter, the connection
  socket, and a map of advanced connection information

  Any :params we pass to the socket constructor
  (i.e. assets/js/socket.js) will be available as the first
  argument in UserSocket.connect

         def connect(_params, socket, _connect_info) do
           {:ok, socket}
         end
  """
  def connect(%{"token" => token}, socket, _connect_info) do
    case Phoenix.Token.verify(
      socket,
      "user socket",
      token,
      max_age: @max_age
    ) do
      {:ok, user_id} ->
        {:ok, assign(socket, :user_id, user_id)}

      {:error, _reason} ->
        :error
    end
  end

  @doc """
  The id function lets us identify the socket
  based on some state stored in the socket itself
  like the user ID
         def id(_socket), do: nil
  """
  def id(socket), do: "users_socket:#{socket.assigns.user_id}"

end
