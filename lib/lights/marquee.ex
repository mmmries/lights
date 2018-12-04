defmodule Lights.Marquee do
  defstruct offset: 0,
            pause: 200,
            pixels: [[],[],[],[],[]]

  def new(opts) do
    message = Keyword.fetch!(opts, :message)
    pixels = message_to_pixels(message)
    %__MODULE__{pixels: pixels}
  end

  def message_to_pixels(message) do
    message_to_pixels(message, [[],[],[],[],[]])
  end

  defp message_to_pixels(<<>>, pixels), do: pixels
  defp message_to_pixels(<< char, rest :: binary>>, pixels) do
    new_pixels = Lights.Alphabet.pixels(char)
    pixels =
      pixels
      |> Enum.with_index()
      |> Enum.map(fn({line, index}) ->
        line ++ Enum.at(new_pixels, index)
      end)
    message_to_pixels(rest, pixels)
  end
end
