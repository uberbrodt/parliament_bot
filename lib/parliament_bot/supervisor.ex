defmodule ParliamentBot.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def new_bot_instance(token) do
    IO.puts(token)
  end

  def init(_) do
    children = [
      worker(ParliamentBot.Slack, [], restart: :temporary),
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
