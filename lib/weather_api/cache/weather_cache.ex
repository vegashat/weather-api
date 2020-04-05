defmodule WeatherApi.Cache.WeatherCache do
    use GenServer
    alias WeatherApi.Models.{Weather,Location}

    @caching_time 60 * 10
    def start_link do
        GenServer.start_link(__MODULE__, %{}, name: :weather_cache)
    end

    def init(_) do
        state = %{
            weather: %{}
        }

        {:ok, state}
    end

    def set_weather(%Weather{} = weather) do
        GenServer.cast(:weather_cache, {:set_weather, weather})
    end

    def get_weather(%Location{} = location) do
        GenServer.call(:weather_cache, {:get_weather, location})
    end

    #Callbacks
    def handle_call({:get_weather, %Location{} = location}, _from, state) do
        key = generate_key(location)
        weather_map = Map.get(state, :weather)
        weather = Map.get(weather_map, key)

        case weather do
            nil -> IO.puts "No weather exists"
            weather ->
                #Delete from cache if expired
                {:ok, now} = DateTime.shift_zone(DateTime.utc_now, "America/Chicago")
                case DateTime.diff(now, weather.current.date) > @caching_time do
                    true ->
                        IO.puts "Removing Cache"
                        Map.delete(state, key)
                        {:reply, nil, state}
                    _ ->
                        IO.puts("Weather not expired")
                        {:reply, weather, state}
                end
        end

    end

    def handle_cast({:set_weather, %Weather{} = weather}, state) do
        key = generate_key(weather.location)
        state = put_in(state, [:weather, key], weather)

        {:noreply, state}
    end

    defp generate_key(%Location{} = location) do
        MapSet.new(["name", location.name])
    end
end
