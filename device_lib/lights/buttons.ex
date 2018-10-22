defmodule Lights.Buttons do
  use GenServer
  alias ElixirALE.GPIO

  @toggle_pin 17
  @color_pin 27
  @animation_pin 22

  def start_link(nil) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(nil) do
    [@toggle_pin, @color_pin, @animation_pin] |> Enum.each(fn(pin) ->
      {:ok, pid} = GPIO.start_link(pin, :input)
      GPIO.set_int(pid, :rising)
    end)
    {:ok, nil}
  end

  def handle_info({:gpio_interrupt, @toggle_pin, _event}, state) do
    :ok = Lights.Painter.toggle()
    {:noreply, state}
  end
  def handle_info({:gpio_interrupt, @color_pin, _event}, state) do
    :ok = Lights.Painter.change_color()
    {:noreply, state}
  end
  def handle_info({:gpio_interrupt, @animation_pin, _event}, state) do
    :ok = Lights.Painter.change_animation()
    {:noreply, state}
  end
end
