defmodule ParliamentStateMachine.StateTransitions do
  @moduledoc """
  Documentation for ParliamentStateMachine.StateTransitions
  """
  use GenStateMachine

  def init(_) do
    {:ok, nil, nil}
  end 

  ### We begin with quorum
  def handle_event({:call, from}, :call_to_order, _, _) do
    {:next_state, :initial_quorum, nil, [{:reply, from, 'The assembly will now take quorum.  All voting members make yourselves known.'}]}
  end
  def handle_event({:call, from}, :quorum_met, :initial_quorum, _) do
    {:next_state, :session_open, nil, [{:reply, from, 'Sufficient voting members being known, this session is open.'}]}
  end
  def handle_event({:call, from}, :quorum_not_met, :initial_quorum, _) do
    {:next_state, :session_closed, nil, [{:reply, from, 'Insufficient members appear for quorum.  This session is closed.'}]}
  end

  ### Adjournment
  def handle_event({:call, from}, :motion_to_adjourn, :session_open, _) do
    {:next_state, :second_adjourn, nil, [{:reply, from, 'Adjournment has been moved.  Is there a second?'}]}
  end
  def handle_event({:call, from}, :seconded, :second_adjourn, _) do
    {:next_state, :vote_on_adjournment, nil, [{:reply, from, 'Adjournment has been moved and seconded.  Vote.'}]}
  end
  def handle_event({:call, from}, :vote_aye, :vote_on_adjournment, _) do
    {:next_state, :session_closed, nil, [{:reply, from, 'Adjournment passes.  The session is closed.'}]}
  end
  def handle_event({:call, from}, :vote_nay, :vote_on_adjournment, _) do
    {:next_state, :session_open, nil, [{:reply, from, 'Adjournment fails.  The session remains open.'}]}
  end
  ### Adjournment motion must come from open session
  def handle_event({:call, from}, :motion_to_adjourn, state,  _) do
    {:next_state, state, nil, [{:reply, from, 'Adjournment must come from open session.  The motion is out of order.'}]}
  end

  ### Main motions
  def handle_event({:call, from}, :motion_of_business, :session_open, _) do
    {:next_state, :second_main, nil, [{:reply, from, 'Business before the assembly has been proposed.  Is there a second to begin debate?'}]}
  end
  def handle_event({:call, from}, :seconded, :second_main, _) do
    {:next_state, :vote_on_main, nil, [{:reply, from, 'Debate on new business has been moved and seconded.  We now vote to proceed to debate.'}]}
  end
  def handle_event({:call, from}, :vote_aye, :vote_on_main, _) do
    {:next_state, :debate, nil, [{:reply, from, 'Debate now begins.'}]}
  end
  def handle_event({:call, from}, :vote_nay, :vote_on_main, _) do
    {:next_state, :session_open, nil, [{:reply, from, 'Debate fails.  The session remains open.'}]}
  end
  ### Adjournment motion must come from open session
  def handle_event({:call, from}, :motion_of_business, state,  _) do
    {:next_state, state, nil, [{:reply, from, 'New business must come from open session.  The motion is out of order.'}]}
  end

  ### Closing debate
  def handle_event({:call, from}, :motion_of_previous_question, :debate, _) do
    {:next_state, :second_previous_question, nil, [{:reply, from, 'Cloture of debate has been moved.  Is there a second?'}]}
  end
  def handle_event({:call, from}, :seconded, :second_previous_question, _) do
    {:next_state, :vote_on_cloture, nil, [{:reply, from, 'Cloture has been moved and seconded.  We now vote to end to debate.'}]}
  end
  def handle_event({:call, from}, :vote_aye, :vote_on_cloture, _) do
    {:next_state, :vote_on_business, nil, [{:reply, from, 'Debate ends.  We now vote on the business at hand.'}]}
  end
  def handle_event({:call, from}, :vote_nay, :vote_on_cloture, _) do
    {:next_state, :debate, nil, [{:reply, from, 'Cloture fails. Continue debating.'}]}
  end
  def handle_event({:call, from}, :motion_of_previous_question, state,  _) do
    {:next_state, state, nil, [{:reply, from, 'No debate is currently taking place.  The motion is out of order.'}]}
  end

  ### Decision 
  def handle_event({:call, from}, :vote_aye, :vote_on_business, _) do
    {:next_state, :session_open, nil, [{:reply, from, 'The business at hand is adopted.'}]}
  end
  def handle_event({:call, from}, :vote_nay, :vote_on_business, _) do
    {:next_state, :session_open, nil, [{:reply, from, 'The business at hand is rejected.'}]}
  end


  ### Generic out of order stuff
  def handle_event({:call, from}, :seconded, state, _) do
    {:next_state, state, nil, [{:reply, from, 'No motion is before the assembly.  A second is out of order.'}]}
  end

  def handle_event({:call, from}, _, state, _) do
    {:next_state, state, nil, [{:reply, from, 'Member is out of order.'}]}
  end
  def handle_event(event_type, event_content, state, data) do
    # Call the default implementation from GenStateMachine
    super(event_type, event_content, state, data)
  end
end
