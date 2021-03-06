defmodule ParliamentBot.Session.SessionsSupervisor do
  @moduledoc """
  Starts and lookups up Sessions
  """
  use Supervisor

  def start_link([client_id: client_id]) do
    Supervisor.start_link(__MODULE__, [], name: client_id)
  end

  def dispatch_to_session(_session_id, _cmd, _message, _user) do
  end

  def init(_) do
    children = [
      worker(ParliamentBot.Session, [], restart: :transient)
    ]
    supervise(children, :simple_one_for_one)
  end
end
