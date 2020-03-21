defmodule WeatherApi.Models.Alert do
    @derive Jason.Encoder
    defstruct title: nil, severity: nil, description: nil
end