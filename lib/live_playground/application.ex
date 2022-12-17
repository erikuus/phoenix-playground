defmodule LivePlayground.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      LivePlayground.Repo,
      # Start the Telemetry supervisor
      LivePlaygroundWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: LivePlayground.PubSub},
      # Start the Endpoint (http/https)
      LivePlaygroundWeb.Endpoint
      # Start a worker by calling: LivePlayground.Worker.start_link(arg)
      # {LivePlayground.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LivePlayground.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LivePlaygroundWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
