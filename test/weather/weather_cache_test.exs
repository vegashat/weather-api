defmodule WeatherApi.WeatherCacheTest do
    use ExUnit.Case
    alias WeatherApi.Models.{Location, Weather}
    alias WeatherApi.Cache.WeatherCache
    
    doctest WeatherApi

    test "get_and_set_weather" do
        location = %Location{name: "Moore, OK", latitude: 35.3395135, longitude: -97.4867045 }
        weather = %Weather{location: location}

        WeatherCache.set_weather(weather)

        cached_weather = WeatherCache.get_weather(location)

        assert weather == cached_weather

    end
end