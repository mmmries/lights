defmodule Lights.Bounce do
  use GenServer
  alias Lights.Strand
  alias Nerves.Neopixel

  @channel 0
  @intensity 31
  @period 10

  def start_link(nil) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def change_direction(), do: GenServer.call(__MODULE__, :change_direction)

  @impl GenServer
  def init(nil) do
    schedule_paint()
    {:ok, %Strand{}}
  end

  @impl GenServer
  def handle_call(:change_direction, _from, state) do
    state = Strand.change_direction(state)
    {:reply, :ok, state}
  end

  @impl GenServer
  def handle_info(:paint, state) do
    render(state.which_pixel)
    schedule_paint()
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

  defp schedule_paint, do: Process.send_after(self(), :paint, @period)
end
