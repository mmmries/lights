defmodule Lights.TemperatureTest do
  use ExUnit.Case, async: true

  test "parsing data from the thermocouple" do
    sample = "65 01 4b 46 7f ff 0b 10 2c : crc=2c YES\n65 01 4b 46 7f ff 0b 10 2c t=22312\n"
    assert Lights.Temperature.parse(sample) == {:ok, 22.312}
  end

  test "it handles other cases" do
    assert Lights.Temperature.parse("wat") == {:error, :could_not_parse}
  end
end
