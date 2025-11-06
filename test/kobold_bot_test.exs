defmodule KoboldBotTest do
  use ExUnit.Case
  doctest KoboldBot

  test "greets the world" do
    assert KoboldBot.hello() == :world
  end
end
