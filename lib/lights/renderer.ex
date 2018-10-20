defmodule Lights.Renderer do
  @moduledoc """
  Turns a %Lights.Strand{} struct into a tuple of {intensity, pixels}
  """

  alias Lights.Bounce

  def render(%Bounce{which_pixel: which, intensity: intensity}) do
    {intensity, pixels(which)}
  end

  defp pixels(which) do
    {0, 0, 0}
    |> List.duplicate(60)
    |> List.replace_at(which, {255, 255, 255})
  end
end
