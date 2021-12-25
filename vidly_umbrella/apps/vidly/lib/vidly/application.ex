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

      # Start the PubSub system
      {Phoenix.PubSub, name: Vidly.PubSub},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Vidly.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
