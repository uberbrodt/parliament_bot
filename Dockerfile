# Set the Docker image you want to base your image off.
# I chose this one because it has Elixir preinstalled.
FROM elixir:1.4

# Compile app
RUN mkdir /app
WORKDIR /app

# Install Elixir Deps
ADD mix.* ./
RUN mix local.hex --force
RUN mix local.rebar
RUN mix deps.get
RUN mix compile

# Install app
ADD . /app
RUN mix compile
CMD [ "mix", "run", "--no-halt" ]
