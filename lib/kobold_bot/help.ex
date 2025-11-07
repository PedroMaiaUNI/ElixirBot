defmodule Weavbot.Help do
  @moduledoc """
  Exibe uma lista de comandos disponíveis do Weavbot.
  """

  def handle_help_command(_msg) do
    """

    🐦 `!bird` - Mostra uma imagem aleatória de um pássaro e um fato curioso (ENGLISH ONLY).
    🐾 `!pokemon <nome>` - Exibe informações detalhadas sobre um Pokémon, com um bônus de estatistícas Smogon.
    🗺️ `!map <local>` - Mostra detalhes sobre um local solicitado (ENGLISH ONLY).
    📚 `!anilist <tipo> <nome>` - Busca animes, mangás, personagens, staff ou estúdio no AniList.
    💲 `!money <valor> <moeda_origem> <moeda_destino>` - Converte valores entre moedas com base nas taxas atuais.

    💡 **Exemplos:**
    • `!pokemon weavile`
    • `!map ceará`
    • `!anilist anime gintama`
    • `!money 10 USD BRL`

    """
  end
end
