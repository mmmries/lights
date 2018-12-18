defmodule Lights.Painter do
  use GenServer
  alias Lights.Animation

  @animations [
    Lights.Marquee.new(message: "MMMRIES"),
    Lights.Marquee.new(message: "HI UTAH ELIXIR"),
    Lights.Marquee.new(message: "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"),
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
      pixels: pixels,
      pause: pause,
    } = Animation.render(state.current)
    paint(pixels)
    schedule_paint(pause)
    animation = Animation.next(state.current)
    {:noreply, %{state | current: animation}}
  end

  defp schedule_paint(pause) do
    Process.send_after(self(), :paint, pause)
  end

  if @target == "host" do
    @spec paint(Lights.Animation.matrix()) :: :ok
    defp paint(pixels) do
      Enum.each(pixels, fn(row) ->
        Enum.each(row, fn
          ({0,0,0}) -> IO.write(" ")
          (_color) -> IO.write("X")
        end)
        IO.write("\r\n")
      end)
      List.duplicate("\r\n", 5) |> IO.write()
    end
  else
    @spec paint(Lights.Animation.matrix) :: :ok
    defp paint(pixels) do
      pixels |> Enum.with_index() |> Enum.each(fn({row, row_num}) ->
        row |> Enum.with_index() |> Enum.each(fn({color, col_num}) ->
          Blinkchain.set_pixel(%Blinkchain.Point{x: col_num, y: row_num}, color)
        end)
      end)
      Blinkchain.render()
    end
  end
end
