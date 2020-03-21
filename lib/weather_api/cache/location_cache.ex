defmodule WeatherApi.Cache.LocationCache do
    use GenServer
    alias WeatherApi.Models.Location

    def start_link do
        GenServer.start_link(__MODULE__, %{}, name: :location_cache)
    end

    def init(_) do
        state = %{
            location: %{}
        }
        {:ok, state}
    end
    
    def set_location(%Location{} = location) do
        GenServer.cast(:location_cache, {:set_location, location})
    end

    def get_location(name) do
        GenServer.call(:location_cache, {:get_location, name})
    end 

    #Callbacks
    def handle_call({:get_location, name}, _from, state) do
        location_map = Map.get(state, :location)
        location = Map.get(location_map, name)

        {:reply, location, state}
    end

    def handle_cast({:set_location, %Location{} = location}, state) do
        key = location.name
        state = put_in(state, [:location, key], location)

        {:noreply, state}
    end
end