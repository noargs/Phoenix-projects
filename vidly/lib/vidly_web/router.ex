defmodule VidlyWeb.Router do
  use VidlyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {VidlyWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug VidlyWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VidlyWeb do
    pipe_through :browser

#    "$ mix phx.routes" to output available routes in iex shell
#    get "/users" show list of users, UserController.index
#    get "/users/:id" show individual user, UserController.show
#    get "/users/new", form with "create user" submit button to add "name" and "username", UserController.new
#    post "/users/create", if user created redirect to index page, UserController.create
    resources "/users", UserController, only: [:index, :show, :new, :create] # exclude :edit, :delete

#    get "/sessions/new", to show a form to login, SessionController.new
#    post "/sessions", to log in and redirect to index page, SessionController.create
#    delete "/sessions/:id" to log out
    resources "/sessions", SessionController, only: [:new, :create, :delete]

    get "/watch/:id", WatchController, :show

    get "/", PageController, :index
  end

  scope "/manage", VidlyWeb do
    pipe_through [:browser, :authenticate_user]

    resources "/videos", VideoController
  end

  # Other scopes may use custom stacks.
  # scope "/api", VidlyWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: VidlyWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
