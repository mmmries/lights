defmodule Lights.Buttons do
  use GenServer
  alias ElixirALE.GPIO

  @direction_pin 17

  def start_link(nil) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(nil) do
    {:ok, pid} = GPIO.start_link(@direction_pin, :input)
    GPIO.set_int(pid, :rising)
    {:ok, nil}
  end

  def handle_info({:gpio_interrupt, @direction_pin, _event}, state) do
    :ok = Lights.Painter.change_direction()
    {:noreply, state}
  end
end
