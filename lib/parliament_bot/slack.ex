defmodule ParliamentBot.Slack do
  use Slack
  alias ParliamentBot.Parser
  alias ParliamentStateMachine.StateMachine
  @moduledoc """
  Documentation for ParliamentBot.
  """

  @private_channel_id "D6FKZ94AE"
  @public_channel_id "C6F4A6A0H"

  defmacro interpret_message(text, message, slack) do
    quote do
      # Not currently sure why the string interpolation is needed
      # but slack doesn't see a message if it's passed in as a bare variable.
      chair_text = unquote(text) |> Parser.parse_text() |> StateMachine.event(unquote(message).channel)
      send_message("#{chair_text}", unquote(message).channel, unquote(slack))
    end
  end

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name} / #{slack.me.id}"
    ParliamentStateMachine.Supervisor.start_link 
    ParliamentStateMachine.Supervisor.start_state_machine(@private_channel_id)
    ParliamentStateMachine.Supervisor.start_state_machine(@public_channel_id)

    {:ok, state}
  end

  ### Message welcoming us to the slack server
  def handle_event(%{type: "hello"}, _slack, state) do
    IO.puts "Got hello message"
    {:ok, state}
  end

  ### Message in the parlibot private channel.  There's got to be a better way
  ### to figure out what the channel ID is.
  def handle_event(message = %{type: "message", channel: @private_channel_id}, slack, state) do
    IO.puts "Got private message in #{message.channel}"
    interpret_message(message.text, message, slack)
    {:ok, state}
  end

  ### Message that parlibot overhears.
  def handle_event(message = %{type: "message"}, slack, state) do
    IO.puts "Got public message in #{message.channel}"
    rex = ~r/^<@#{slack.me.id}>:? (.*)/
    if Regex.match?(rex, message.text) do
      [[_, text]] = Regex.scan(rex, message.text)
      interpret_message(text, message, slack)
    end
    {:ok, state}
  end

  ### Error condition
  def handle_event(message = %{type: "error"}, _, state) do
    IO.inspect message
    {:ok, state}
  end

  ### Some event we don't have an explicit handler for.
  def handle_event(somethingelse, _, state) do
    IO.puts "Got a #{somethingelse.type}"
    {:ok, state}
  end


end
