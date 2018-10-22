defmodule Lights.OscillateTest do
  use ExUnit.Case, async: true
  alias Lights.{Animation,Oscillate}

  test "it starts out on the even pixels" do
    oscillate = Oscillate.new()
    assert oscillate == %Oscillate{which: :evens, color: {255, 0, 0}}
  end

  test "it switches to the other set" do
    oscillate = Oscillate.new() |> Animation.next()
    assert oscillate == %Oscillate{which: :odds, color: {255, 0, 0}}
  end

  test "it renders the evens" do
    %{
      pixels:    [first, second | rest],
      pause:     pause,
      intensity: intensity,
    } = Animation.render(%Oscillate{which: :evens})
    assert pause == 150
    assert intensity == 15
    assert Enum.count(rest) == 58
    assert first == {255, 0, 0}
    assert second == {0, 0, 0}
  end

  test "it renders the odds" do
    %{
      pixels:    [first, second | rest],
      pause:     pause,
      intensity: intensity,
    } = Animation.render(%Oscillate{which: :odds, color: {0, 255, 0}})
    assert pause == 150
    assert intensity == 15
    assert Enum.count(rest) == 58
    assert first == {0, 0, 0}
    assert second == {0, 255, 0}
  end

  test "it changes color" do
    oscillate = %Oscillate{color: {255, 0, 0}}
    oscillate = Animation.change_color(oscillate)
    assert oscillate.color == {0, 255, 0}
  end

  test "toggles change the render timing" do
    oscillate = Oscillate.new()
    assert %{pause: 150} = Animation.render(oscillate)
    oscillate = Animation.toggle(oscillate)
    assert %{pause: 100} = Animation.render(oscillate)
  end
end
