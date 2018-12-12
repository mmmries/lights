defmodule Lights.BounceTest do
  use ExUnit.Case, async: true
  alias Lights.{Animation,Bounce}

  test "it starts out on the first pixel" do
    bounce = Bounce.new()
    assert bounce == %Bounce{which_pixel: 0, direction: :up}
  end

  test "it moves up" do
    bounce = Bounce.new() |> Animation.next()
    assert bounce == %Bounce{which_pixel: 1, direction: :up}
  end

  test "it bounces off the top end of the strip" do
    bounce = %Bounce{which_pixel: 255, direction: :up} |> Animation.next()
    assert bounce == %Bounce{which_pixel: 254, direction: :down}
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
    assert Enum.count(rest) == 255
    assert first == {255, 255, 255}
    assert Enum.all?(rest, &(&1 == {0, 0, 0}))
  end

  test "it can change colors" do
    first = Bounce.new()
    second = Animation.change_color(first)
    assert first.color != second.color
  end

  test "it can toggle" do
    first = Bounce.new()
    second = Animation.toggle(first)
    assert first.direction != second.direction
  end
end
