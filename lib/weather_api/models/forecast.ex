defmodule WeatherApi.Models.Forecast do
    @derive Jason.Encoder
    defstruct date: nil, temp_high: nil, temp_low: nil, icon: nil, wind_speed: nil, wind_direction: nil, moon_phase: nil, summary: nil, humidity: nil, precip_probability: nil
end