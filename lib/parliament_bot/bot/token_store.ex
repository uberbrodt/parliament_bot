defmodule ParliamentBot.Bot.TokenStore do
  @moduledoc """
  Save and retrieve bot tokens
  """
  use GenServer
  alias ParliamentBot.Bot

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end
  
  def start_bots do
    tokens = []
    Enum.each(tokens, fn x ->
      Bot.start(x)
    end)
  end
end
