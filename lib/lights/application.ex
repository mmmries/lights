defmodule Lights.Application do
  use Application

  @moduledoc false
  @target Mix.Project.config()[:target]

  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: Lights.Supervisor]
    Supervisor.start_link(children(@target), opts)
  end

  defp children("host") do
    []
  end
  defp children("rpi") do
    [
      {Nerves.Neopixel, [pin: 18, count: 60]},
      {Lights.Bounce, nil},
      {Lights.Buttons, nil},
    ]
  end
end
