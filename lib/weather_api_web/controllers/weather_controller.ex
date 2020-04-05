defmodule WeatherApiWeb.WeatherController do
    use WeatherApiWeb, :controller

    alias WeatherApi.WeatherService

    def ping(conn, _parms) do
        json(conn, %{message: "Working"})
    end

    def location(conn, %{"location" => location} = params) do
        weather = WeatherService.get_weather(location)
        json(conn, Map.from_struct(weather))
    end

end
