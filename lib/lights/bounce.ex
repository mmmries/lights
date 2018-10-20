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

  def change_direction(), do: GenServer.call(__MODULE__, :change_direction)

  @impl GenServer
  def init(nil) do
    state = %Strand{}
    schedule_paint(state)
    {:ok, state}
  end

  @impl GenServer
  def handle_call(:change_direction, _from, state) do
    state = Strand.change_direction(state)
    {:reply, :ok, state}
  end

  @impl GenServer
  def handle_info(:paint, state) do
    Strand.render(state)
    state = Strand.next(state)
    schedule_paint(state)
    {:noreply, state}
  end

  defp schedule_paint(_state) do
    Process.send_after(self(), :paint, @period)
  end
end
