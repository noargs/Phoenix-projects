defmodule EctoAssoc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EctoAssocWeb.Telemetry,
      EctoAssoc.Repo,
      {DNSCluster, query: Application.get_env(:ecto_assoc, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: EctoAssoc.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: EctoAssoc.Finch},
      # Start a worker by calling: EctoAssoc.Worker.start_link(arg)
      # {EctoAssoc.Worker, arg},
      # Start to serve requests, typically the last entry
      EctoAssocWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EctoAssoc.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EctoAssocWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
