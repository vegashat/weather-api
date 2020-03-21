defmodule WeatherApi.Models.Weather do
    alias WeatherApi.Models.{Location, Current, Forecast}
    @derive Jason.Encoder
    defstruct location: %Location{}, current: %Current{}, forecasts: [%Forecast{}]
end