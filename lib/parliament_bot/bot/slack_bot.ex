defmodule ParliamentBot.SlackBot do
  @moduledoc """
  Documentation for ParliamentBot.
  """
  use Slack

  require Logger

  alias ParliamentBot.MsgParser
  alias ParliamentBot.Session.SessionsSupervisor

  defstruct [:id, :name]


  def handle_connect(slack, state) do
    Logger.info fn ->
      "Connected as #{slack.me.name} / #{slack.me.id}"
    end
    #File.write("slack_struct_proper.txt", inspect(slack, pretty: true))
    {:ok, %{state | id: slack.me.id, name: slack.me.name}}
  end

  def parlibot_mentions_regex(bot_id) do
    ~r/^<@#{bot_id}>:? (.*)/
  end

  def handle_event(%{type: "message", text: text, channel: channel = "D" <> <<_ :: binary>>, user: user}, slack, state) do
    Logger.debug fn ->
       "Matched DM! text: #{text}, channel: #{channel}, user: #{user}"
    end
    msg = """
    Hi! Currently I can't answer DM's, but eventually you'll be able to query for help and
    perhaps meeting minutes.
    """
    send_message(msg, channel, slack)
    {:ok, state}
  end

  @doc """
  Handle messages mentioning parlibot
  """
  def handle_event(%{type: "message", text: text, channel: channel, user: user}, slack, state) do
    Logger.debug fn ->
      "text: #{text}, channel: #{channel}, user: #{user}"
    end

    if Regex.match?(parlibot_mentions_regex(slack.me.id), text) do
      [[_, text]] = Regex.scan(parlibot_mentions_regex(slack.me.id), text)
      result = 
        SessionsSupervisor.dispatch_to_session(channel,
          MsgParser.parse_text(text),
          text,
          user)
      send_message(result, channel, slack)
    end
    {:ok, state}
  end

  ### Some event we don't have an explicit handler for.
  def handle_event(%{type: type} = message, _slack, state) do
    Logger.debug fn ->
      "Got a #{type} message"
    end
    message |> inspect(pretty: true) |> IO.puts
    {:ok, state}
  end
end
