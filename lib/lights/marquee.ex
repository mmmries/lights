defmodule Lights.Marquee do
  defstruct color:      {255, 255, 255},
            max_offset: 0,
            offset:     0,
            pause:      200,
            pixels:     [[],[],[],[],[]]

  def new(opts) do
    message = Keyword.fetch!(opts, :message)
    pixels = message_to_pixels(message)
    max_offset = (pixels |> Enum.at(0) |> length()) - 32
    %__MODULE__{max_offset: max_offset, pixels: pixels}
  end

  def message_to_pixels(message) do
    # padding the message with spaces produces an effect where the
    # letters scroll onto the screen and then off at the end before
    # resetting
    message_to_pixels("        "<>message<>"        ", [[],[],[],[],[],[],[],[]])
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

  defimpl Lights.Animation do
    alias Lights.Marquee

    @colors [
      {255, 0, 0},
      {0, 255, 0},
      {0, 0, 255},
      {255, 255, 255},
    ]

    @pauses [
      200,
      150,
      100,
      50,
    ]

    @matrix_width 32

    def next(%Marquee{max_offset: max, offset: offset}=marquee) when offset > max do
      %{marquee | offset: 0}
    end
    def next(%Marquee{offset: offset}=marquee) do
      %{marquee | offset: offset + 1}
    end

    def render(%Marquee{}=marquee) do
      pixels =
        marquee.pixels
        |> Enum.map(fn(row) ->
          Enum.slice(row, marquee.offset, @matrix_width)
        end)
        |> transpose()
        |> List.flatten()
        |> Enum.map(fn
          (1) -> marquee.color
          (0) -> {0, 0, 0}
        end)

      %{
        pixels:    pixels,
        intensity: 9,
        pause:     marquee.pause,
      }
    end

    def transpose([]), do: []
    def transpose([[]|_]), do: []
    def transpose(a) do
      [Enum.map(a, &hd/1) | transpose(Enum.map(a, &tl/1))]
    end

    def change_color(%Marquee{}=marquee) do
      %{ marquee | color: Lights.Wrap.next(@colors, marquee.color) }
    end

    def toggle(%Marquee{}=marquee) do
      %{ marquee | pause: Lights.Wrap.next(@pauses, marquee.pause) }
    end
  end
end
