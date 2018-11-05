defmodule Lights.PainterTest do
  use ExUnit.Case, async: true
  alias Lights.Painter

  test "temperature_to_intensity" do
    assert Painter.temperature_to_intensity(0.0) == 15
    assert Painter.temperature_to_intensity(20.0) == 15
    assert Painter.temperature_to_intensity(25.0) == 135
    assert Painter.temperature_to_intensity(30.0) == 255
    assert Painter.temperature_to_intensity(40.0) == 255
  end
end
