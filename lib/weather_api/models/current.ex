defmodule WeatherApi.Models.Current do
    alias WeatherApi.Models.Alert
    @derive Jason.Encoder
    defstruct date: nil, temp: nil, feels_like: nil, icon: nil, wind_speed: nil, wind_direction: nil, summary: nil, humidity: nil, precip_probability: nil, alert: %Alert{}
end