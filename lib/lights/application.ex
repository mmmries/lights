defmodule Lights.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @target Mix.Project.config()[:target]

  use Application

  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: Lights.Supervisor]
    children = [
      {Nerves.Neopixel, [pin: 18, count: 60]},
    ]
    Supervisor.start_link(children, opts)
  end
end
