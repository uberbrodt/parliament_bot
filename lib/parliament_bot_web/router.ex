defmodule ParliamentBotWeb.Router do
  use ParliamentBotWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ParliamentBotWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

  end

  scope "/api", ParliamentBotWeb do
    pipe_through :api
    post "/:bot_token", PageController, :open_bot
  end

  # Other scopes may use custom stacks.
  # scope "/api", ParliamentBotWeb do
  #   pipe_through :api
  # end
end
