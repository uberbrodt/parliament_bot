defmodule ParliamentStateMachine.StateMachine do
  @moduledoc """
  Documentation for ParliamentStateMachine
  """
  use GenStateMachine
  alias ParliamentStateMachine.StateTransitions

  def start_link(name) do
    GenStateMachine.start_link(StateTransitions, {:session_closed}, name: via_tuple(name))
  end

  defp via_tuple(state_machine) do
    {:via, :gproc, {:n, :l, {:channel, state_machine}}}
  end

  def event(event, state_machine) do
    IO.puts "Eventing #{event}"
    GenStateMachine.call(via_tuple(state_machine), event)
  end

end
