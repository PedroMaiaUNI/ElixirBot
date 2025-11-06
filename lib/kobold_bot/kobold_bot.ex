defmodule KoboldBot do

  use Nostrum.Consumer

  alias Nostrum.Api
  alias KoboldBot.Game
  alias KoboldBot.Dog
  alias KoboldBot.PokeCommand

  def handle_event({:MESSAGE_CREATE, msg, _ws}) do
    cond do
      String.starts_with?(msg.content, "!ping") -> Api.Message.create(msg.channel_id, "pong!")
      String.starts_with?(msg.content, "!ppt") -> Api.Message.create(msg.channel_id, Game.handle_ppt_command(msg))
      String.starts_with?(msg.content, "!dog") -> Api.Message.create(msg.channel_id, Dog.handle_dog_command)
      String.starts_with?(msg.content, "!pokemon") -> Api.Message.create(msg.channel_id, PokeCommand.handle_poke_command(msg))
      true -> :ignore
    end
  end

end
