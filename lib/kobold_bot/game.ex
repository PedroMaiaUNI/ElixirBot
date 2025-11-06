defmodule PFBot.Game do

  @valid_options ["pedra", "papel", "tesoura"]

  def handle_ppt_command(msg) do
    msg.content
    |> String.split(" ", parts: 2)
    |> case do
      ["!ppt", player_option] when player_option in @valid_options -> play_game(player_option)
      _ -> "Comando inválido, use !ppt <pedra|papel|tesoura>"
    end
  end

  defp play_game(player_option) do
    bot_option = Enum.random(@valid_options)

    msg = cond do
      player_option == bot_option -> "Houve um empate! 😐"

      player_option == "pedra" && bot_option == "tesoura" ||
      player_option == "papel" && bot_option == "pedra"   ||
      player_option == "tesoura" && bot_option == "papel"  -> "Você venceu! 👍"

      true -> "Eu venci! 🤖"

    end

    "#{msg} \n Você escolheu **#{player_option}** e eu escolhi **#{bot_option}**"

  end

end
