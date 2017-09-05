defmodule ParliamentBot.Session.SessionSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [
      supervisor(ParliamentBot.Meeting.MeetingSupervisor, [], restart: :permanent),
      worker(ParliamentBot.Meeting.MeetingStore, [], restart: :permanent)
    ]
    supervise(children, :one_for_one)
  end
end
