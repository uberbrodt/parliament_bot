defmodule ParliamentBot.Bot do
  use Supervisor


  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  defp via_tuple(token) do
    {:via, Registry, {:slackbot_registry, token}}
  end

  def start(token) do
    Supervisor.start_child(__MODULE__, [token])
  end

  def stop(token) do
    Supervisor.stop(via_tuple(token), :shutdown)
  end

  def init(_) do
    children = [
      worker(ParliamentBot.BotSupervisor, [], restart: :transient)
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

end
