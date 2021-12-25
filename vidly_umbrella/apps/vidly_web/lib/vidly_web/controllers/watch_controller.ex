defmodule VidlyWeb.WatchController do
  use VidlyWeb, :controller

  alias Vidly.Multimedia

  def show(conn, %{"id" => id}) do
    video = Multimedia.get_video!(id)
    render(conn, "show.html", video: video)
  end

end
