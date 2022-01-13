defmodule PentoWeb.PageLive do
  use PentoWeb, :live_view

  @doc """
  Live route maps an incoming web request "/" to
  specified live view i.e. "PageLive"

  Request to that endpoint will start up the live view process
      live "/", PageLive, :index

  Process will initialize the live view's state by
  setting up the socket in a function called "mount/3"

  Live view keeps data describing state in a socket
      iex(1)> Phoenix.LiveView.Socket.__struct__

  Initial socket looks like this:
      %Socket{
        assigns: %{
          query: "",
          results: %{}
        }
      }
  """
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "", results: %{})}
  end

end
