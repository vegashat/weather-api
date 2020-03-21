defmodule WeatherApiWeb.Router do
  use WeatherApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WeatherApiWeb do
    pipe_through :api

    get "/ping/", WeatherController, :ping
    get "/location/:location", WeatherController, :location
  end
end
