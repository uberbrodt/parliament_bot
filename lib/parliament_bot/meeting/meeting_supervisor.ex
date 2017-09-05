defmodule ParliamentBot.Meeting.MeetingSupervisor do
  @moduledoc """
  Stores meetings
  """
  use Supervisor
  
  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [
      worker(ParliamentBot.Session, [], restart: :transient)
    ]
    supervise(children, :simple_one_for_one)
  end

end
