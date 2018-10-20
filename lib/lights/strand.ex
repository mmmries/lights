defmodule Lights.Strand do
  defstruct which_pixel: 0,
            direction:   :up

  @target Mix.Project.config()[:target]
  @intensity 31

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

  def render(%__MODULE__{which_pixel: which}) do
    which |> pixels() |> paint(@intensity)
  end

  defp pixels(which) do
    {0, 0, 0}
    |> List.duplicate(60)
    |> List.replace_at(which, {255, 255, 255})
  end

  if @target == "host" do
    def paint(pixels, _intensity) do
      strs = Enum.map(pixels, fn
        ({0, 0, 0}) -> " "
        (_pixel)    -> "X"
      end)
      IO.write(["\r" | strs])
    end
  else
    @channel 0
    def paint(pixels, intensity) do
      Neopixel.render(@channel, {intensity, pixels})
    end
  end
end
