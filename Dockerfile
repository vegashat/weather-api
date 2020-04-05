FROM elixir:latest AS weather_elixir
WORKDIR /app
ENV MIX_HOME=/opt/mix
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install hex phx_new 1.4.11
COPY . .
RUN mix deps.get --only prod
RUN MIX_ENV=prod mix compile
EXPOSE 4000