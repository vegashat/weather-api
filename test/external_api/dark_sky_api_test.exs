
defmodule WeatherApi.Test.ExternalApi.DarkSkyApiTest do
    use ExUnit.Case
    alias WeatherApi.ExternalApi.DarkSky
    
    doctest WeatherApi

    test "north_wind_speed_returns_north" do

        wind_direction = DarkSky.wind_direction(359)

        assert wind_direction == "N"

    end
end