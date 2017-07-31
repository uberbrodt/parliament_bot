defmodule ParliamentBotWeb.PageController do
  use ParliamentBotWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def open_bot(conn, %{"bot_token" => token}) do
    ParliamentBot.BotSupervisor.new_bot_instance(token)
    json conn, %{}
  end
end
