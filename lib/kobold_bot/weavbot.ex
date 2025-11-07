defmodule WeavBot do

  use Nostrum.Consumer

  alias Nostrum.Api
  alias WeavBot.PokeCommand
  alias WeavBot.Anilist
  alias WeavBot.Bird
  alias WeavBot.Map
  alias WeavBot.Money

  def handle_event({:MESSAGE_CREATE, msg, _ws}) do
    cond do

      #----- COMANDOS DO TRABALHO -----#

      #comando simples

      String.starts_with?(msg.content, "!bird") -> Api.Message.create(msg.channel_id, Bird.handle_bird_command)

      #comandos de 1 argumento
      String.starts_with?(msg.content, "!pokemon") -> Api.Message.create(msg.channel_id, PokeCommand.handle_poke_command(msg))
      String.starts_with?(msg.content, "!map") -> Api.Message.create(msg.channel_id, Map.handle_map_command(msg))

      #comandos de 2 ou mais argumentos
      String.starts_with?(msg.content, "!anilist") -> Api.Message.create(msg.channel_id, Anilist.handle_anilist_command(msg))
      String.starts_with?(msg.content, "!money") -> Api.Message.create(msg.channel_id, Money.handle_money_command(msg))

      true -> :ignore
    end
  end

end
