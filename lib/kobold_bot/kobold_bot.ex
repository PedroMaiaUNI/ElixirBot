defmodule KoboldBot do

  use Nostrum.Consumer

  alias Nostrum.Api
  alias KoboldBot.Game
  alias KoboldBot.Dog
  alias KoboldBot.PokeCommand
  alias KoboldBot.Anilist
  alias KoboldBot.Bird

  def handle_event({:MESSAGE_CREATE, msg, _ws}) do
    cond do
      String.starts_with?(msg.content, "!ping") -> Api.Message.create(msg.channel_id, "pong!")
      String.starts_with?(msg.content, "!ppt") -> Api.Message.create(msg.channel_id, Game.handle_ppt_command(msg))
      String.starts_with?(msg.content, "!dog") -> Api.Message.create(msg.channel_id, Dog.handle_dog_command)

      #----- COMANDOS DO TRABALHO -----#

      #comando simples

      String.starts_with?(msg.content, "!bird") -> Api.Message.create(msg.channel_id, Bird.handle_bird_command)

      #comandos de 1 argumento
      String.starts_with?(msg.content, "!pokemon") -> Api.Message.create(msg.channel_id, PokeCommand.handle_poke_command(msg))


      #comandos de 2 ou mais argumentos
      String.starts_with?(msg.content, "!anilist") -> Api.Message.create(msg.channel_id, Anilist.handle_anilist_command(msg))

      true -> :ignore
    end
  end

end
