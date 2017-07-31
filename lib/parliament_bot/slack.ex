defmodule ParliamentBot.Slack do
  use Slack
  alias ParliamentBot.Parser
  @moduledoc """
  Documentation for ParliamentBot.
  """

  defmacro interpret_message(text, message, slack) do
    quote do
      IO.puts "Got '#{unquote(text)}'"
      unquote(text)
      |> Parser.parse_text()
      |> send_message(unquote(message).channel, unquote(slack))
    end
  end

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name} / #{slack.me.id}"
    {:ok, state}
  end

  ### Message welcoming us to the slack server
  def handle_event(%{type: "hello"}, _slack, state) do
    IO.puts "Got hello message"
    {:ok, state}
  end

  ### Message in the parlibot private channel.  There's got to be a better way
  ### to figure out what the channel ID is.
  def handle_event(message = %{type: "message", channel: "D6FKZ94AE"}, slack, state) do
    interpret_message(message.text, message, slack)
    {:ok, state}
  end

  ### Message that parlibot overhears.
  def handle_event(message = %{type: "message"}, slack, state) do
    rex = ~r/^<@#{slack.me.id}>:? (.*)/
    if Regex.match?(rex, message.text) do
      [[_, text]] = Regex.scan(rex, message.text)
      interpret_message(text, message, slack)
    end
    {:ok, state}
  end

  ### Some event we don't have an explicit handler for.
  def handle_event(somethingelse, _, state) do
    IO.puts "Got a #{somethingelse.type}"
    {:ok, state}
  end


end
