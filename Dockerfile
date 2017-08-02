# Set the Docker image you want to base your image off.
# I chose this one because it has Elixir preinstalled.
FROM elixir:1.4

RUN mkdir /app
WORKDIR /app

# Install Elixir Deps
ADD mix.* ./
RUN mix local.hex --force
RUN mix local.rebar
RUN mix deps.get
RUN mix compile

# Install app
CMD [ "mix", "run", "--no-halt" ]
ADD . /app
RUN mix compile
