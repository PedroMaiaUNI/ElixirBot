defmodule WeavBotTest do
  use ExUnit.Case
  doctest WeavBot

  test "greets the world" do
    assert WeavBot.hello() == :world
  end
end
