defmodule Test do
  def token do
    token = System.get_env("PARLIBOT_SLACK_TOKEN")
  end

  def start_slackbot do
    {:ok, pid} = ParliamentBot.Bot.start(token)
    pid
  end
end
