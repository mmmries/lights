defmodule Lights.Painter do
  use GenServer
  alias Lights.Animation

  @animations [
    Lights.Bounce.new(),
    Lights.Oscillate.new(),
    Lights.Pause.new(),
    Lights.Marquee.new(message: "MMMRIES"),
    Lights.Marquee.new(message: "HI UTAH ELIXIR"),
  ]
  @target Mix.Project.config()[:target]

  def start_link(nil) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def change_animation(), do: GenServer.call(__MODULE__, :change_animation)

  def change_color(), do: GenServer.call(__MODULE__, :change_color)

  def toggle(), do: GenServer.call(__MODULE__, :toggle)

  @impl GenServer
  def init(nil) do
    send self(), :paint
    animation = Lights.Wrap.next(@animations, nil)
    state = %{animation: animation, current: animation}
    {:ok, state}
  end

  @impl GenServer
  def handle_call(:change_animation, _from, %{animation: animation}=state) do
    next_animation = Lights.Wrap.next(@animations, animation)
    {:reply, :ok, %{state | animation: next_animation, current: next_animation}}
  end
  def handle_call(:change_color, _from, %{current: animation}=state) do
    animation = Animation.change_color(animation)
    {:reply, :ok, %{state | current: animation}}
  end
  def handle_call(:toggle, _from, state) do
    animation = Animation.toggle(state.current)
    {:reply, :ok, %{state | current: animation}}
  end

  @impl GenServer
  def handle_info(:paint, state) do
    %{
      intensity: intensity,
      pixels: pixels,
      pause: pause,
    } = Animation.render(state.current)
    paint({intensity, pixels})
    schedule_paint(pause)
    animation = Animation.next(state.current)
    {:noreply, %{state | current: animation}}
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
