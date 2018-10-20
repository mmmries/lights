defmodule Lights.Application do
  use Application

  @moduledoc false
  @target Mix.Project.config()[:target]

  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: Lights.Supervisor]
    children = platform_children(@target) ++ [
      {Lights.Bounce, nil},
    ]
    Supervisor.start_link(children, opts)
  end

  defp platform_children("host") do
    []
  end
  defp platform_children("rpi") do
    [
      {Nerves.Neopixel, [pin: 18, count: 60]},
      {Lights.Buttons, nil},
    ]
  end
end
