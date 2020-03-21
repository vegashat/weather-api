defmodule WeatherApi.Cache.CacheSupervisor do
    use Supervisor
    alias WeatherApi.Cache.{WeatherCache, LocationCache}

    def start_link(_) do
        Supervisor.start_link(__MODULE__, [])
    end
    
    def init(_) do
        children = [
            worker(WeatherCache, []),
            worker(LocationCache, [])
        ]

        supervise(children, strategy: :one_for_one)

    end 

end
