defmodule KoboldBot.PokeCommand do
  @endpoint "https://pokeapi.co/api/v2/pokemon/"

  @type_emojis %{
    "normal" => "⚪",
    "fire" => "🔥",
    "water" => "💧",
    "electric" => "⚡",
    "grass" => "🌿",
    "ice" => "❄️",
    "fighting" => "🥊",
    "poison" => "☠️",
    "ground" => "🌍",
    "flying" => "🕊️",
    "psychic" => "🔮",
    "bug" => "🐛",
    "rock" => "🪨",
    "ghost" => "👻",
    "dragon" => "🐉",
    "dark" => "🌑",
    "steel" => "⚙️",
    "fairy" => "✨"
  }

  def handle_poke_command(msg) do
    parts = String.split(msg.content, " ", trim: true)
    name = Enum.at(parts, 1)

    cond do
      is_nil(name) -> "Uso: `!pokemon <name>` (ex: `!pokemon weavile`)"

      true ->
        url = @endpoint <> String.downcase(name)

        case Finch.build(:get, url) |> Finch.request(MyFinch) do
          {:ok, %{status: 200, body: body}} ->
            with {:ok, json} <- JSON.decode(body) do
              name_cap = String.capitalize(name)
              types = extract_types(json)
              height = json["height"] / 10
              weight = json["weight"] / 10
              ability = get_in(json, ["abilities", Access.at(0), "ability", "name"]) |> String.capitalize()

              """
              **#{name_cap}**
              🌀 Tipos: #{types}
              💪 Habilidade principal: #{ability}
              📏 Altura: #{height} m
              ⚖️ Peso: #{weight} kg

              🔗 [Mais detalhes](https://pokemondb.net/pokedex/#{String.downcase(name_cap)})
              """
            end

          {:ok, %{status: 404}} ->
            "Pokémon não encontrado."

          {:error, _reason} ->
            "Erro ao acessar a PokéAPI."
        end
    end
  end

  defp extract_types(json) do
    json["types"]
    |> Enum.map(fn t ->
      type = t["type"]["name"]
      emoji = Map.get(@type_emojis, type, "❓")
      "#{emoji} #{String.capitalize(type)}"
    end)
    |> Enum.join(" / ")
  end

end
