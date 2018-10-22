defmodule Lights.Oscillate do
  defstruct which: :evens,
            color: {255, 0, 0},
            pause: 150



  def new, do: %__MODULE__{}

  def pixels(%__MODULE__{which: :evens, color: color}) do
    [color, {0, 0, 0}] |> List.duplicate(30) |> List.flatten
  end
  def pixels(%__MODULE__{which: :odds, color: color}) do
    [{0, 0, 0}, color] |> List.duplicate(30) |> List.flatten
  end

  defimpl Lights.Animation do
    alias Lights.Oscillate

    @colors [
      {255, 0, 0},
      {0, 255, 0},
      {0, 0, 255},
      {255, 255, 255},
    ]

    @pauses [
      150,
      100,
      50,
      25
    ]

    def next(%Oscillate{which: :evens}=animation), do: %{animation | which: :odds}
    def next(%Oscillate{which: :odds}=animation), do: %{animation | which: :evens}

    def render(%Oscillate{pause: pause}=animation) do
      %{
        pixels:    Oscillate.pixels(animation),
        intensity: 15,
        pause:     pause,
      }
    end

    def change_color(%Oscillate{color: color}=animation) do
      %{ animation | color: Lights.Wrap.next(@colors, color) }
    end

    def toggle(%Oscillate{pause: pause}=animation) do
      %{ animation | pause: Lights.Wrap.next(@pauses, pause) }
    end
  end
end
