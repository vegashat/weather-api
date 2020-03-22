
defmodule WeatherApi.LocationCacheTest do
    use ExUnit.Case
    alias WeatherApi.Models.Location
    alias WeatherApi.Cache.LocationCache
    
    doctest WeatherApi

    test "get_and_set_location" do
        name = "Moore, OK"
        location = %Location{name: name, latitude: 35.3395135, longitude: -97.4867045}

        LocationCache.set_location(location)

        cached_location = LocationCache.get_location(name)

        assert location == cached_location

    end
end