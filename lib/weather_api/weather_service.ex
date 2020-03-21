defmodule  WeatherApi.WeatherService do
    alias WeatherApi.Models.{Location, Forecast, Weather}
    alias WeatherApi.Cache.{WeatherCache, LocationCache}
    alias WeatherApi.ExternalApi.{CageApi, DarkSky}


    def get_weather(location_name) when is_binary(location_name) do
        location_name
        |> get_location()
        |> lookup_weather()
    end
    
    def get_weather(location_name, :use_file) when is_binary(location_name) do
        location_name
        |> get_location()
        |> lookup_weather(:use_file)
    end

    def lookup_weather_from_cache(%Location{} = location, :use_file) do
        case WeatherCache.get_weather(location) do
            nil ->
                weather = lookup_weather(location, :use_file)
                WeatherCache.set_weather(weather)
                weather
            weather -> weather
        end
    end

    def lookup_weather_from_cache(%Location{} = location) do
        case WeatherCache.get_weather(location) do
            nil ->
                weather = lookup_weather(location)
                WeatherCache.set_weather(weather)
                weather
            weather -> weather
        end
    end

    defp get_location(name) do
        case LocationCache.get_location(name) do
            nil ->
                location = lookup_location(name)
                LocationCache.set_location(location)
                location
            location -> location
        end
    end

    def lookup_location(name) do
        IO.puts "Name"
        IO.inspect name
        case CageApi.get_coordinates(name) do
            {:ok, coordinates} ->
                %Location{name: name, latitude: coordinates["lat"], longitude: coordinates["lng"]}
            _ ->
                "Error looking up location"
        end
    end

    def lookup_weather(%Location{} = location) do
        DarkSky.lookup_weather(location)
    end

    def lookup_weather(%Location{} = location, :use_file) do
        DarkSky.lookup_weather(location, :use_file)
    end
end
