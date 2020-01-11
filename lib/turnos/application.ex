defmodule Turnos.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Turnos.Repo,
      # Start the endpoint when the application starts
      TurnosWeb.Endpoint
      # Starts a worker by calling: Turnos.Worker.start_link(arg)
      # {Turnos.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Turnos.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TurnosWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
