defmodule Lights.MarqueeTest do
  use ExUnit.Case, async: true
  alias Lights.Marquee

  test "can render an 'X' to pixels" do
    marquee = Marquee.new(message: "X")
    assert marquee.pixels == [
      [1,0,0,0,1,0],
      [0,1,0,1,0,0],
      [0,0,1,0,0,0],
      [0,1,0,1,0,0],
      [1,0,0,0,1,0],
    ]
  end

  test "can render an 'LOL' message" do
    marquee = Marquee.new(message: "LOL")
    assert marquee.pixels == [
      [1,0,0,0,0,0,1,1,1,1,1,0,1,0,0,0,0,0],
      [1,0,0,0,0,0,1,0,0,0,1,0,1,0,0,0,0,0],
      [1,0,0,0,0,0,1,0,0,0,1,0,1,0,0,0,0,0],
      [1,0,0,0,0,0,1,0,0,0,1,0,1,0,0,0,0,0],
      [1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,0],
    ]
  end
end
