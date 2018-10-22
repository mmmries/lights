defmodule Lights.PauseTest do
  use ExUnit.Case, async: true
  alias Lights.{Animation,Pause}

  test "it can be started" do
    pause = Pause.new()
    assert is_map(pause)
  end

  test "it renders blank pixels with a long timeout" do
    %{
      pixels:    pixels,
      pause:     150,
      intensity: 0,
    } = Animation.render(Pause.new())
    assert Enum.all?(pixels, &(&1 == {0, 0, 0}))
  end

  test "next returns the same thing" do
    pause = Pause.new()
    assert pause == Animation.next(pause)
  end

  test "changing colors does nothing" do
    pause = Pause.new()
    assert pause == Animation.change_color(pause)
  end

  test "toggling does nothing" do
    pause = Pause.new()
    assert pause == Animation.toggle(pause)
  end
end
