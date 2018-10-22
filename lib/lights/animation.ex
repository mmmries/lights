defprotocol Lights.Animation do
  @type pixel :: {byte(), byte(), byte()}

  @doc """
  This function computes the next state of the animation.
  """
  @spec next(struct()) :: struct()
  def next(animation)

  @doc """
  This function renders down an animation state down to a list of pixels,
  an intensity between 0..255 and an animation pause between 0..1000 for
  how many milliseconds to wait before the next render
  """
  @spec render(struct()) :: %{pixels: [pixel()], intensity: byte(), pause: 0..1000}
  def render(animation)

  @doc """
  This represents a generic "toggle" action. The user has clicked a button
  and each animation can choose how to react. Ie change speed, direction, etc
  """
  @spec toggle(struct()) :: struct()
  def toggle(animation)

  @doc """
  The user has clicked the change color button. The animation should update its
  state accordingly.
  """
  @spec toggle(struct()) :: struct()
  def change_color(animation)
end
