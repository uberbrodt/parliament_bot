defmodule ParliamentBot.BotSupervisor do
  @moduledoc false
  use Supervisor
  require Logger
  alias ParliamentBot.Session.SessionsSupervisor

  def start_link([token: token, client_id: _client_id]) do
    Logger.info("BotSupervisor started")
    name = via_tuple(token)
    Supervisor.start_link(__MODULE__, token, name: name, shutdown: 2_000)
  end

  defp via_tuple(client_id) do
    {:via, Registry, {:slackbot_registry, client_id}}
  end

  def init([token: token, client_id: client_id]) do
    children = [
      worker(Slack.Bot, [ParliamentBot.SlackBot, %ParliamentBot.SlackBot{client_id: client_id}, token], restart: :transient),
      supervisor(SessionsSupervisor, [client_id: client_id])
    ]
    supervise(children, strategy: :one_for_one)
  end
end
