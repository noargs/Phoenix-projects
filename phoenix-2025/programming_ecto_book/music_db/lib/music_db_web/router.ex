defmodule MusicDBWeb.Router do
  use MusicDBWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MusicDBWeb do
    pipe_through :api
  end
end
