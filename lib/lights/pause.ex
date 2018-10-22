defmodule Lights.Pause do
  defstruct pause: 150

  def new, do: %__MODULE__{}

  defimpl Lights.Animation do
    alias Lights.Pause

    def change_color(%Pause{}=pause), do: pause
    def toggle(%Pause{}=pause), do: pause
    def next(%Pause{}=pause), do: pause
    def render(%Pause{pause: pause}) do
      %{
        pixels: List.duplicate({0,0,0}, 60),
        intensity: 0,
        pause: pause,
      }
    end
  end
end
