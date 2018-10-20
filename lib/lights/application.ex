defmodule Lights.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: Lights.Supervisor]
    children = [
      {Nerves.Neopixel, [pin: 18, count: 60]},
      {Lights.Bounce, nil},
    ]
    Supervisor.start_link(children, opts)
  end
end
