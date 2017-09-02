defmodule ParliamentBot.BotSupervisor do
  use Supervisor

  require Logger

  def start_link(token) do
    Logger.info("BotSupervisor started")
    name = via_tuple(token)
    Supervisor.start_link(__MODULE__, token, name: name, shutdown: 2_000)
  end

  defp via_tuple(token) do
    {:via, Registry, {:slackbot_registry, token}}
  end

  def init(token) do
    children = [
      worker(Slack.Bot, [ParliamentBot.SlackBot, %ParliamentBot.SlackBot{}, token], restart: :transient)
    ]
    supervise(children, strategy: :one_for_one)
  end
end
