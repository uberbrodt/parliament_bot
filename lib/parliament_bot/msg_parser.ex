defmodule ParliamentBot.MsgParser do
  def parse_text(text) do
    IO.puts "Parsing #{text}"
    cond do
      # Generic seconds and votes
      Regex.match?(~r/second/i, text) -> :seconded
      Regex.match?(~r/ayes have it/i, text) -> :vote_aye
      Regex.match?(~r/nays have it/i, text) -> :vote_nay

      # Quorum
      Regex.match?(~r/call.*to order/i, text) -> :call_to_order
      Regex.match?(~r/not have( a)? quorum/i, text) -> :quorum_not_met
      Regex.match?(~r/have( a)? quorum/i, text) -> :quorum_met

      # Adjournment
      Regex.match?(~r/move.*adjourn/i, text) -> :motion_to_adjourn

      # Cloture
      Regex.match?(~r/move.*the previous question/i, text) -> :motion_of_previous_question
      Regex.match?(~r/move.*close debate/i, text) -> :motion_of_previous_question
      Regex.match?(~r/move.*debate be closed/i, text) -> :motion_of_previous_question

      # Main motions
      Regex.match?(~r/move.*/i, text) -> :motion_of_business

      true -> :noop
    end
  end
end
