use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :weather_api, WeatherApiWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :weather_api,
  cage_api_key: "cbdb7cc95eba419591d73a604eae7c97",
  dark_sky_api_url: "https://api.net/forecast/",
  dark_sky_api_key: "089d95be05fc8d28ea114a302bfabc41"