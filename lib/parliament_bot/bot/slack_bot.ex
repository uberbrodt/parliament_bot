defmodule ParliamentBot.SlackBot do
  @moduledoc """
  Documentation for ParliamentBot.
  """
  use Slack

  require Logger

  alias ParliamentBot.MsgParser

  defstruct [:id, :name]

  def handle_connect(slack, state) do
    Logger.info fn ->
      "Connected as #{slack.me.name} / #{slack.me.id}"
    end
    {:ok, %{state | id: slack.me.id, name: slack.me.name}}
  end

  def handle_event(%{type: "message", text: text, channel: channel, user: user}, slack, state) do
    Logger.debug fn ->
      "text: #{text}, channel: #{channel}, user: #{user}"
    end

    rex = ~r/^<@#{slack.me.id}>:? (.*)/
    if Regex.match?(rex, text) do
      [[_, text]] = Regex.scan(rex, text)
      result = 
        ParliamentBot.SessionSupervisor.dispatch_to_session(channel,
          MsgParser.parse_text(text),
          text,
          user)
      send_message(result, channel, slack)
    end
    {:ok, state}
  end

  ### Some event we don't have an explicit handler for.
  def handle_event(message = %{type: type}, _slack, state) do
    Logger.debug fn ->
      "Got a #{type} message"
    end
    message |> inspect(pretty: true) |> IO.puts
    {:ok, state}
  end
end
