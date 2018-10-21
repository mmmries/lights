defmodule Lights.Application do
  use Application

  @moduledoc false
  @target Mix.Project.config()[:target]

  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: Lights.Supervisor]
    Supervisor.start_link(children(), opts)
  end

  if @target == "host" do
    defp children() do
      []
    end
  else
    defp children() do
      [
        {Nerves.Neopixel, [pin: 18, count: 60]},
        {Lights.Painter, %Lights.Bounce{}},
        {Lights.Buttons, nil},
      ]
    end
  end
end
