defprotocol Lights.Animation do
  @type pixel :: {byte(), byte(), byte()}

  @doc """
  This function computes the next state of the animation.
  """
  @spec next(any()) :: any()
  def next(animation)

  @doc """
  This function renders down an animation state down to a list of pixels,
  an intensity between 0..255 and an animation pause between 0..1000 for
  how many milliseconds to wait before the next render
  """
  @spec render(any()) :: %{pixels: [pixel()], intensity: byte(), pause: 0..1000}
  def render(animation)

  @doc """
  This changes the direction of the animation in response to the user
  hitting the change direction button
  """
  @spec change_direction(any()) :: any()
  def change_direction(animation)
end
