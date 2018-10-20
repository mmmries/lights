defmodule Lights.Strand do
  defstruct which_pixel: 0,
            direction:   :up

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
end
