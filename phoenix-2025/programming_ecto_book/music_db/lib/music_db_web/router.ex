defmodule MusicDbWeb.Router do
  use MusicDbWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MusicDbWeb do
    pipe_through :api
  end
end
