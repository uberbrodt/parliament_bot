defmodule ParliamentBot.Slack do
  use Slack
  @moduledoc """
  Documentation for ParliamentBot.
  """
  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}"
    IO.puts slack.me.id
    {:ok, state}
  end


  def handle_event(message = %{type: "message"}, _slack, state) do
    IO.puts(inspect(message))
    {:ok, state}
  end

  #def handle_event(_message = %{type: "message"}, _slack, state) do
  # #send_message("I got a message!", message.channel, slack)
  #  {:ok, state}
  #end

  def handle_event(_, _, state), do: {:ok, state}
end
