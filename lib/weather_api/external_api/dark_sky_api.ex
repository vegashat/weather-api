defmodule WeatherApi.ExternalApi.DarkSky do
    alias WeatherApi.Models.{Location, Weather, Forecast, Alert, Current}

    @dark_sky_api_key Application.get_env(:weather_api, :dark_sky_api_key)
    @dark_sky_url     Application.get_env(:weather_api, :dark_sky_api_url)

    @test_data_file_path "data/weather.json"

    def lookup_weather(%Location{} = location) do
        weather = get_weather_json_data(location.latitude, location.longitude)
        |> do_lookup_weather(location)

        weather
    end

    def lookup_weather(%Location{} = location, :use_file) do
       get_weather_json_data_from_file()
       |> do_lookup_weather(location)
    end

    def do_lookup_weather(json, %Location{} = location) do
        weather =
        json
        |> decode()
        |> parse_weather()

       %Weather{weather | location: location}
    end

    def get_weather_json_data(lat, long) do
      IO.inspect @dark_sky_url
      IO.inspect @dark_sky_api_key

      url = "#{@dark_sky_url}/#{@dark_sky_api_key}/#{lat},#{long}"

      IO.inspect url
      case Mojito.request(method: :get, url: url) do
        {:ok, response} ->
            response.body
        {:error, err} -> "Error requesting weather from Dark Sky: #{err.message}"
      end
    end

    defp get_weather_json_data_from_file() do
        File.read!(@test_data_file_path)
    end

    defp decode(json) do
        case Jason.decode(json, [{:keys, :atoms}]) do
            {:ok, data} ->
                data
            {:err, _} ->
                "Error parsing json data"
        end
    end

    defp parse_weather(json) do
        current = parse_current(json)
        forecasts = Enum.map(json[:daily][:data], &parse_forecast(&1))

        %Weather{current: current, forecasts: forecasts}
    end

    def parse_current(json) do
        IO.inspect json[:currently]
        with current = json[:currently] do
            base = parse_base_weather(current, :current)
            current = %Current{base |
                temp: current[:temperature],
                feels_like: current[:apparentTemperature]
            }

            IO.puts "current parsed correctly"

            case Map.has_key?(json, :alerts) do
                true ->
                    with alerts = Enum.at(json[:alerts],0) do
                        alert = %Alert{
                            title:  alerts[:title],
                            severity: alerts[:severity],
                            description: alerts[:description]
                        }

                        %Current{current | alert: alert}
                    end
                _ -> current
            end

        end
    end

    def parse_forecast(forecast) do
        base_weather = parse_base_weather(forecast, :forecast)

        IO.inspect base_weather
        %Forecast{base_weather |
            temp_high: forecast[:temperatureHigh],
            temp_low: forecast[:temperatureLow],
            moon_phase: forecast[:moonPhase]
        }
    end

    defp parse_base_weather(json, :current) do

        %Current{
            date: convert_to_cst(json[:time]),
            summary: json[:summary],
            icon: json[:icon],
            humidity: json[:humidity],
            wind_speed: json[:windSpeed],
            wind_direction: wind_direction(json[:windBearing]),
            precip_probability: json[:precipProbability]
        }
    end

    defp parse_base_weather(json, :forecast) do
        IO.inspect json[:precipProbability]
        %Forecast{
            date: convert_to_cst(json[:time]),
            summary: json[:summary],
            icon: json[:icon],
            humidity: json[:humidity],
            wind_speed: json[:windSpeed],
            wind_direction: wind_direction(json[:windBearing]),
            precip_probability: json[:precipProbability]
        }
    end

    def convert_to_cst(unix_time) do
        IO.inspect unix_time
        {:ok, date} = DateTime.from_unix(unix_time)
        {:ok, date} = DateTime.shift_zone(date, "America/Chicago")

        date
    end

    def wind_direction(direction_in_degrees) do
        case direction_in_degrees do
            x when x in 348..360 -> "N"
            x when x in 1..11 -> "N"
            x when x in 11..33 -> "NNE"
            x when x in 33..56 -> "NE"
            x when x in 56..78 -> "ENE"
            x when x in 78..101 -> "E"
            x when x in 101..123 -> "ESE"
            x when x in 123..146 -> "SE"
            x when x in 146..168 -> "SSE"
            x when x in 168..191 -> "S"
            x when x in 191..213 -> "SSW"
            x when x in 213..236 -> "SW"
            x when x in 236..258 -> "WSW"
            x when x in 258..281 -> "W"
            x when x in 282..303 -> "WNW"
            x when x in 303..326 -> "NW"
            x when x in 326..348 -> "NNW"
        end
    end

    def moon_phase(lunation_fraction) do
        lunation_int =
            Decimal.from_float(lunation_fraction * 100)
            |> Decimal.round(0, :down)
            |> Decimal.to_integer()

        IO.inspect lunation_int

        case lunation_int do
            x when x in 0..0 -> "new"
            x when x in 1..24 -> "waxing-crescent"
            x when x in 25..25 -> "first-quarter"
            x when x in 26..49 -> "waxing-gibbous"
            x when x in 50..50 -> "full-moon"
            x when x in 51..74 -> "waning-gibbous"
            x when x in 75..75 -> "last-quarter"
            x when x in 76..99 -> "waning-crescent"
        end
    end
end
