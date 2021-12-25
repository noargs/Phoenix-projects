defmodule VidlyWeb.VideoChannel do
  use VidlyWeb, :channel

  alias Vidly.{Accounts, Multimedia}

  alias VidlyWeb.AnnotaionView

#  def join("videos:" <> video_id, _params, socket) do
#    {:ok, assign(socket, :video_id, String.to_integer(video_id))}
##    :timer.send_interval(5_000, :ping)
##    {:ok, socket}
#  end


  @doc """
  Refresh your page, and the messages disappear
  from the UI. They’re still in the database, but we need to pass the messages
  to the client when a user joins the channel. We could do this by pushing an
  event to the client after each user joins, but Phoenix provides a 3-tuple join
  signature to both join the channel and send a join response at the same time.
  """
  def join("videos:" <> video_id, params, socket) do
    send(self(), :after_join)
    last_seen_id = params["last_seen_id"] || 0
    video_id = String.to_integer(video_id)
    video = Multimedia.get_video!(video_id)

    annotations =
      video
      |> Multimedia.list_annotations(last_seen_id)
      |> Phoenix.View.render_many(AnnotaionView, "annotation.json")

    {:ok, %{annotations: annotations}, assign(socket, :video_id, video_id)}
  end


  def handle_in(event, params, socket) do
    user = Accounts.get_user!(socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end


  def handle_in("new_annotation", params, user, socket) do
    case Multimedia.annotate_video(user, socket.assigns.video_id, params) do
      {:ok, annotation} ->
        broadcast!(socket, "new_annotation", %{
          id: annotation.id,
          ## below we are sending all the users, the "user.json"
          ## as a key user with value of whatever in json file
          ## this whole elixir map %{id, user, body, at}
          ## will be received by vidChannel.on("new_annotation, (resp) => {})
          ## where response argument "resp" will be destructured into {user, body, at}
          ## vidChannel.on("new_annotation",({user, body, at}) => {})
          user: VidlyWeb.UserView.render("user.json", %{user: user}),
          body: annotation.body,
          at: annotation.at
        })
        {:reply, :ok, socket}

      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

  def handle_info(:after_join, socket) do
    push(socket, "presence_state", VidlyWeb.Presence.list(socket))
    {:ok, _} = VidlyWeb.Presence.track(
      socket,
      socket.assigns.user_id,
      %{device: "browser"})
    {:noreply, socket}
  end


#  def handle_in("new_annotation", params, socket) do
#    broadcast!(socket, "new_annotation", %{
#      user: %{username: "anon"},
#      body: params["body"],
#      at: params["at"]
#    })
#    {:reply, :ok, socket}
#  end


#  def handle_info(:ping, socket) do
#    count = socket.assigns[:count] || 1
#    push(socket, "ping", %{count: count})
#
#    {:noreply, assign(socket, :count, count + 1)}
#  end


end
