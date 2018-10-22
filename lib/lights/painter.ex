defmodule Lights.Painter do
  use GenServer
  alias Lights.Animation

  @animations [Lights.Bounce, Lights.Oscillate]
  @target Mix.Project.config()[:target]

  def start_link(animation) do
    GenServer.start_link(__MODULE__, animation, name: __MODULE__)
  end

  def change_animation(), do: GenServer.call(__MODULE__, :change_animation)

  def change_color(), do: GenServer.call(__MODULE__, :change_color)

  def toggle(), do: GenServer.call(__MODULE__, :toggle)

  @impl GenServer
  def init(animation) do
    send self(), :paint
    {:ok, animation}
  end

  @impl GenServer
  def handle_call(:change_animation, _from, animation) do
    current_type = Map.get(animation, :__struct__)
    current_index = Enum.find_index(@animations, fn(candidate) -> candidate == current_type end)
    next_index = rem(current_index + 1, Enum.count(@animations))
    next_type = Enum.at(@animations, next_index)
    animation = apply(next_type, :new, [])
    {:reply, :ok, animation}
  end
  def handle_call(:change_color, _from, animation) do
    animation = Animation.change_color(animation)
    {:reply, :ok, animation}
  end
  def handle_call(:toggle, _from, animation) do
    animation = Animation.toggle(animation)
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
