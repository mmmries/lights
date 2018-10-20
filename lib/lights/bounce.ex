defmodule Lights.Bounce do
  use GenServer
  alias Lights.Strand
  alias Nerves.Neopixel

  @channel 0
  @intensity 31
  @period 33

  def start_link(nil) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(nil) do
    :timer.send_interval(@period, :paint)
    state = %Strand{}
    {:ok, state}
  end

  def handle_info(:paint, state) do
    render(state.which_pixel)
    {:noreply, Strand.next(state)}
  end

  def render(num) do
    Neopixel.render(@channel, {@intensity, pixels(num)})
    :timer.sleep(@period)
  end

  defp pixels(num) do
    {0, 0, 0}
    |> List.duplicate(60)
    |> List.replace_at(num, {255, 255, 255})
  end
end
