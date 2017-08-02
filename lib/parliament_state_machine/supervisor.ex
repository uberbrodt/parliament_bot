defmodule ParliamentStateMachine.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: :parliament_bot_state_machine_supervisor)
  end

  def start_state_machine(name) do
    Supervisor.start_child(:parliament_bot_state_machine_supervisor, [name])
  end

  def init(_) do
    children = [
      worker(ParliamentStateMachine.StateMachine, [])
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
