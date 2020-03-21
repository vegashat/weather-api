defmodule WeatherApi.Models.Location do
    @derive Jason.Encoder
    defstruct name: nil, latitude: nil, longitude: nil
end