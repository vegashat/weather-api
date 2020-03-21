defmodule WeatherApi.Cache.WeatherCache do
    use GenServer
    alias WeatherApi.Models.{Weather,Location}

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

        {:reply, weather, state}
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