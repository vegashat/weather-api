
defmodule WeatherApi.WeatherTest do
    use ExUnit.Case
    alias WeatherApi.Models.{Location, Weather}
    alias WeatherApi.WeatherService


    doctest WeatherApi

    test "cagex_location_lookup_matches_moore_ok" do
        name = "Moore,OK"
        location = %Location{name: name, latitude: 35.3395135, longitude: -97.4867045}
        
        cagex_location = WeatherService.lookup_location(name)

        assert location == cagex_location
    end


end