defmodule WeatherApi.ExternalApi.CageApi do
    @cage_api_key Application.get_env(:weather_api, :cage_api_key)

    def get_coordinates(location) do
        OpenCagex.set_api_key(@cage_api_key)
        OpenCagex.geocode(location)
    end

end