defmodule Lights.Oscillate do
  defstruct which: :evens,
            color: {255, 0, 0}

  @colors %{
    {255, 0, 0} => {0, 255, 0},
    {0, 255, 0} => {0, 0, 255},
    {0, 0, 255} => {255, 0, 0},
  }

  def change_color(%__MODULE__{color: color}=animation) do
    %{animation | color: Map.get(@colors, color)}
  end

  def pixels(%__MODULE__{which: :evens, color: color}) do
    [color, {0, 0, 0}] |> List.duplicate(30) |> List.flatten
  end
  def pixels(%__MODULE__{which: :odds, color: color}) do
    [{0, 0, 0}, color] |> List.duplicate(30) |> List.flatten
  end

  defimpl Lights.Animation do
    alias Lights.Oscillate

    def next(%Oscillate{which: :evens}=animation), do: %{animation | which: :odds}
    def next(%Oscillate{which: :odds}=animation), do: %{animation | which: :evens}

    def render(%Oscillate{}=animation) do
      %{
        pixels:    Oscillate.pixels(animation),
        intensity: 15,
        pause:     150,
      }
    end

    def change_direction(%Oscillate{}=animation) do
      Oscillate.change_color(animation)
    end
  end
end
