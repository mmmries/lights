defmodule Lights.Painter do
  use GenServer
  alias Lights.Animation

  @animations [Lights.Bounce, Lights.Oscillate, Lights.Pause]
  @target Mix.Project.config()[:target]

  def start_link(animation) do
    GenServer.start_link(__MODULE__, animation, name: __MODULE__)
  end

  def change_animation(), do: GenServer.call(__MODULE__, :change_animation)

  def change_color(), do: GenServer.call(__MODULE__, :change_color)

  def temperature(temperature), do: GenServer.call(__MODULE__, {:temperature, temperature})

  def toggle(), do: GenServer.call(__MODULE__, :toggle)

  def temperature_to_intensity(temperature) do
    cond do
      temperature <= 20.0 -> 15
      temperature >= 30.0 -> 255
      true ->
        ratio = (temperature - 20.0) / 10.0
        trunc(240 * ratio) + 15
    end
  end

  @impl GenServer
  def init(animation) do
    send self(), :paint
    state = %{intensity: 15, animation: animation}
    {:ok, state}
  end

  @impl GenServer
  def handle_call(:change_animation, _from, %{animation: animation}=state) do
    current_type = Map.get(animation, :__struct__)
    current_index = Enum.find_index(@animations, fn(candidate) -> candidate == current_type end)
    next_index = rem(current_index + 1, Enum.count(@animations))
    next_type = Enum.at(@animations, next_index)
    animation = apply(next_type, :new, [])
    {:reply, :ok, %{state | animation: animation}}
  end
  def handle_call(:change_color, _from, %{animation: animation}=state) do
    animation = Animation.change_color(animation)
    {:reply, :ok, %{state | animation: animation}}
  end
  def handle_call({:temperature, temperature}, _from, state) do
    intensity = temperature_to_intensity(temperature)
    {:reply, :ok, %{state | intensity: intensity}}
  end
  def handle_call(:toggle, _from, state) do
    animation = Animation.toggle(state.animation)
    {:reply, :ok, %{state | animation: animation}}
  end

  @impl GenServer
  def handle_info(:paint, state) do
    %{
      pixels: pixels,
      pause: pause,
    } = Animation.render(state.animation)
    paint({state.intensity, pixels})
    schedule_paint(pause)
    animation = Animation.next(state.animation)
    {:noreply, %{state | animation: animation}}
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
