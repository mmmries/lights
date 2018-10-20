defmodule Lights.Painter do
  use GenServer
  alias Lights.{Bounce, Renderer}

  @target Mix.Project.config()[:target]

  def start_link(nil) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def change_direction(), do: GenServer.call(__MODULE__, :change_direction)

  @impl GenServer
  def init(nil) do
    state = %Bounce{}
    schedule_paint(state)
    {:ok, state}
  end

  @impl GenServer
  def handle_call(:change_direction, _from, state) do
    state = Bounce.change_direction(state)
    {:reply, :ok, state}
  end

  @impl GenServer
  def handle_info(:paint, state) do
    state |> Renderer.render() |> paint()
    state = Bounce.next(state)
    schedule_paint(state)
    {:noreply, state}
  end

  defp schedule_paint(%Bounce{render_pause: pause}) do
    Process.send_after(self(), :paint, pause)
  end

  if @target == "host" do
    defp paint({_intensity, pixels}) do
      strs = Enum.map(pixels, fn
        ({0, 0, 0}) -> " "
        (_pixel)    -> "X"
      end)
      IO.write(["\r" | strs])
    end
  else
    alias Nerves.Neopixel
    @channel 0
    defp paint({intensity, pixels}) do
      Neopixel.render(@channel, {intensity, pixels})
    end
  end
end
