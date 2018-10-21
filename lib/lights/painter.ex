defmodule Lights.Painter do
  use GenServer
  alias Lights.Animation

  @target Mix.Project.config()[:target]

  def start_link(animation) do
    GenServer.start_link(__MODULE__, animation, name: __MODULE__)
  end

  def change_direction(), do: GenServer.call(__MODULE__, :change_direction)

  @impl GenServer
  def init(animation) do
    send self(), :paint
    {:ok, animation}
  end

  @impl GenServer
  def handle_call(:change_direction, _from, animation) do
    animation = Animation.change_direction(animation)
    {:reply, :ok, animation}
  end

  @impl GenServer
  def handle_info(:paint, animation) do
    %{
      pixels: pixels,
      pause: pause,
      intensity: intensity,
    } = Animation.render(animation)
    paint({intensity, pixels})
    schedule_paint(pause)
    animation = Animation.next(animation)
    {:noreply, animation}
  end

  defp schedule_paint(pause) do
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
    @channel 0
    defp paint({intensity, pixels}) do
      Nerves.Neopixel.render(@channel, {intensity, pixels})
    end
  end
end
