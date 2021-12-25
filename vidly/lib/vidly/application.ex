defmodule Vidly.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Vidly.Repo,
      # Start the Telemetry supervisor
      VidlyWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Vidly.PubSub},
      # Start the Endpoint (http/https)
      VidlyWeb.Endpoint,
      # Start a worker by calling: Vidly.Worker.start_link(arg)
      # {Vidly.Worker, arg}

      VidlyWeb.Presence
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Vidly.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VidlyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
