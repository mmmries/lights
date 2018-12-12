defmodule Lights.Bounce do
  defstruct which_pixel: 0,
            direction:   :up,
            color:       {255, 255, 255}

  def new, do: %__MODULE__{}

  defimpl Lights.Animation do
    alias Lights.Bounce

    @colors [
      {255, 255, 255},
      {255, 0, 0},
      {0, 255, 0},
      {0, 0, 255},
    ]

    @max 255

    def next(%Bounce{which_pixel: @max, direction: :up}=state) do
      %{ state | which_pixel: @max - 1, direction: :down }
    end
    def next(%Bounce{which_pixel: p, direction: :up}=state) do
      %{ state | which_pixel: p + 1 }
    end
    def next(%Bounce{which_pixel: 0, direction: :down}=state) do
      %{ state | which_pixel: 1, direction: :up }
    end
    def next(%Bounce{which_pixel: p, direction: :down}=state) do
      %{ state | which_pixel: p - 1 }
    end

    def render(%Bounce{}=bounce) do
      %{
        pixels:    pixels(bounce),
        intensity: 15,
        pause:     30,
      }
    end

    def toggle(%Bounce{direction: :up}=state) do
      %{ state | direction: :down }
    end
    def toggle(%Bounce{direction: :down}=state) do
      %{ state | direction: :up }
    end

    def change_color(%Bounce{color: color}=state) do
      %{ state | color: Lights.Wrap.next(@colors, color) }
    end

    defp pixels(%Bounce{which_pixel: which, color: color}) do
      {0, 0, 0}
      |> List.duplicate(@max + 1)
      |> List.replace_at(which, color)
    end
  end
end
