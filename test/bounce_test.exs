defmodule Lights.BounceTest do
  use ExUnit.Case, async: true
  alias Lights.Bounce

  test "it starts out on the first pixel" do
    bounce = %Bounce{}
    assert bounce.which_pixel == 0
  end
end
