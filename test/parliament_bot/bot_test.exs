defmodule ParliamentBot.BotTest do
  use ExUnit.Case

  test "start a new slack bot" do
    {:ok, pid} = ParliamentBot.Bot.start(System.get_env("PARLIBOT_SLACK_TOKEN"))
    shutdown(pid)
  end

  test "one slackbot per a token" do
    token = System.get_env("PARLIBOT_SLACK_TOKEN")
    {:ok, pid} = ParliamentBot.Bot.start(token)
    {:error, {:already_started, existing_pid}} = ParliamentBot.Bot.start(token)
    assert pid == existing_pid
    shutdown(pid)
  end


  def shutdown(pid) when is_pid(pid) do
    :ok = Supervisor.stop(pid, :shutdown)
    assert Process.alive?(pid) == false
  end
end
