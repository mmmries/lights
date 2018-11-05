defmodule Lights.Temperature do
  use GenServer
  require Logger

  # Parse the contents of the thermocouple file
  def parse(str) do
    case Regex.run(~r[\At=(\d+)\z], extract_t_equals(str)) do
      [_, digits] ->
        num = String.to_integer(digits) / 1000.0
        {:ok, num}
      _ ->
        {:error, :could_not_parse}
    end
  end

  # gets rid of all the CRC stuff and just extracts the t=##### part
  defp extract_t_equals(str) do
    str
    |> String.trim()
    |> String.split(" ")
    |> List.last()
  end

  def start_link(nil) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(nil) do
    schedule_parse()
    {:ok, nil}
  end

  def handle_info(:parse, state) do
    try_to_parse_temperature()
    schedule_parse()
    {:noreply, state}
  end

  def handle_info(other, state) do
    Logger.error "#{__MODULE__} received unexpected message #{inspect(other)}"
    {:noreply, state}
  end

  defp try_to_parse_temperature do
    file = "/sys/bus/w1/devices/28-00000761c6d0/w1_slave"
    if File.exists?(file) do
      case file |> File.read!() |> parse() do
        {:ok, temperature} -> Lights.Painter.temperature(temperature)
        _ -> nil
      end
    end
  end

  defp schedule_parse do
    Process.send_after(self(), :parse, 250)
  end
end
