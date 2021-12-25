defmodule InfoSys.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: InfoSys.Worker.start_link(arg)
      # {InfoSys.Worker, arg}

#      {InfoSys.Counter, 5}

#      Supervisor.child_spec({InfoSys.Counter, 5}, restart: :temporary)

#      Supervisor.child_spec({InfoSys.Counter, 15}, id: :long),
#      Supervisor.child_spec({InfoSys.Counter, 5}, id: :short),
#      Supervisor.child_spec({InfoSys.Counter, 10}, id: :medium)
      InfoSys.Cache,
      {Task.Supervisor, name: InfoSys.TaskSupervisor},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
#    opts = [strategy: :one_for_all, name: InfoSys.Supervisor]
    opts = [strategy: :one_for_one, name: InfoSys.Supervisor] # new strategy
    Supervisor.start_link(children, opts)
  end
end
