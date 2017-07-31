defmodule ParliamentBot.BotSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def new_bot_instance(token) do
    Supervisor.start_child(__MODULE__, [ParliamentBot.SlackBot, [], token])
  end

  def init(_) do
    children = [
      worker(Slack.Bot, [], restart: :transient)
    ]
    supervise(children, strategy: :simple_one_for_one)
  end
end
