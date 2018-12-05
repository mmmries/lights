defmodule Lights.Wrap do
  @doc """
  This is a helper function to grab the next thing out of a list.

  iex> Lights.Wrap.next([:one, :two, :three], nil)
  :one
  iex> Lights.Wrap.next([:one, :two, :three], :one)
  :two
  iex> Lights.Wrap.next([:one, :two, :three], :two)
  :three
  iex> Lights.Wrap.next([:one, :two, :three], :three)
  :one
  """
  @spec next(Enum.t(), term()) :: term()
  def next(list, current) do
    current_index = Enum.find_index(list, fn(candidate) -> candidate == current end) || -1
    next_index = rem(current_index + 1, Enum.count(list))
    Enum.at(list, next_index)
  end
end
