defmodule ParliamentBot.Parser do
  @moduledoc """
  Documentation for ParliamentBot.
  """
  def parse_text(text) do
    cond do
      Regex.match?(~r/^move/i, text) -> "So moved."
      Regex.match?(~r/^second/i, text) -> "Seconded."
      true -> "The member is out of order."
    end
  end

end
