defmodule Lights.Bounce do
  defstruct which_pixel: 0,
            direction:   :up,
            intensity:   31,
            render_pause: 33

  def change_direction(%__MODULE__{direction: :up}=state) do
    %{ state | direction: :down }
  end
  def change_direction(%__MODULE__{direction: :down}=state) do
    %{ state | direction: :up }
  end

  def next(%__MODULE__{which_pixel: 59, direction: :up}=state) do
    %{ state | which_pixel: 58, direction: :down }
  end
  def next(%__MODULE__{which_pixel: p, direction: :up}=state) do
    %{ state | which_pixel: p + 1 }
  end
  def next(%__MODULE__{which_pixel: 0, direction: :down}=state) do
    %{ state | which_pixel: 1, direction: :up }
  end
  def next(%__MODULE__{which_pixel: p, direction: :down}=state) do
    %{ state | which_pixel: p - 1 }
  end

  def pixels(%__MODULE__{which_pixel: which}) do
    {0, 0, 0}
    |> List.duplicate(60)
    |> List.replace_at(which, {255, 255, 255})
  end
end

defimpl Lights.Animation, for: Lights.Bounce do
  alias Lights.Bounce

  def next(%Bounce{}=bounce), do: Bounce.next(bounce)
  def render(%Bounce{}=bounce) do
    %{
      pixels:    Bounce.pixels(bounce),
      intensity: 15,
      pause:     30,
    }
  end
end
