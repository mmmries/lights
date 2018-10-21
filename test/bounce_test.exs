defmodule Lights.BounceTest do
  use ExUnit.Case, async: true
  alias Lights.{Animation,Bounce}

  test "it starts out on the first pixel" do
    bounce = %Bounce{}
    assert bounce == %Bounce{which_pixel: 0, direction: :up}
  end

  test "it moves up" do
    bounce = %Bounce{} |> Animation.next()
    assert bounce == %Bounce{which_pixel: 1, direction: :up}
  end

  test "it bounces off the top end of the strip" do
    bounce = %Bounce{which_pixel: 59, direction: :up} |> Animation.next()
    assert bounce == %Bounce{which_pixel: 58, direction: :down}
  end

  test "it moves down" do
    bounce = %Bounce{which_pixel: 50, direction: :down} |> Animation.next()
    assert bounce == %Bounce{which_pixel: 49, direction: :down}
  end

  test "it bounces off the bottom end of the strip" do
    bounce = %Bounce{which_pixel: 0, direction: :down} |> Animation.next()
    assert bounce == %Bounce{which_pixel: 1, direction: :up}
  end

  test "it renders the pixels" do
    %{
      pixels:    [first | rest],
      pause:     pause,
      intensity: intensity,
    } = Animation.render(%Bounce{})
    assert pause == 30
    assert intensity == 15
    assert Enum.count(rest) == 59
    assert first == {255, 255, 255}
    assert Enum.all?(rest, &(&1 == {0, 0, 0}))
  end
end
