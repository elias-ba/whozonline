defmodule Whozonline.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WhozonlineWeb.Telemetry,
      Whozonline.Repo,
      {DNSCluster, query: Application.get_env(:whozonline, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Whozonline.PubSub},
      WhozonlineWeb.Presence,
      # Start the Finch HTTP client for sending emails
      {Finch, name: Whozonline.Finch},
      # Start a worker by calling: Whozonline.Worker.start_link(arg)
      # {Whozonline.Worker, arg},
      # Start to serve requests, typically the last entry
      WhozonlineWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Whozonline.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WhozonlineWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
