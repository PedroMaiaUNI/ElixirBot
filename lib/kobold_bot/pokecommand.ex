defmodule KoboldBot.PokeCommand do
  @pokeapi "https://pokeapi.co/api/v2/pokemon/"
  @smogon_base "https://raw.githubusercontent.com/pkmn/smogon/main/data/stats/gen9ou.json"

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
        url = @pokeapi <> String.downcase(name)

        case Finch.build(:get, url) |> Finch.request(MyFinch) do
          {:ok, %{status: 200, body: body}} ->
            with {:ok, json} <- JSON.decode(body) do
              build_response(name, json)
            end

          {:ok, %{status: 404}} ->
            "Pokémon não encontrado."

          {:error, _reason} ->
            "Erro ao acessar a PokéAPI."
        end
    end
  end

  defp build_response(name, poke_json) do
    name_cap = String.capitalize(name)
    types = extract_types(poke_json)
    height = poke_json["height"] / 10
    weight = poke_json["weight"] / 10
    ability =
      get_in(poke_json, ["abilities", Access.at(0), "ability", "name"])
      |> String.capitalize()

    # Dados competitivos
    smogon_data = fetch_smogon_data(name_cap)

    """
    **#{name_cap}**
    🌀 Tipos: #{types}
    💪 Habilidade principal: #{ability}
    📏 Altura: #{height} m | ⚖️ Peso: #{weight} kg

    ⚔️ **Dados competitivos (Smogon - Gen 9 OU)**
    #{smogon_data}

    🔗 [Mais detalhes (PokémonDB)](https://pokemondb.net/pokedex/#{String.downcase(name)})
    """
  end

  defp fetch_smogon_data(name) do
    case HTTPoison.get(@smogon_base) do
      {:ok, %{status_code: 200, body: body}} ->
        with {:ok, json} <- Jason.decode(body),
             %{"pokemon" => data} <- json,
             poke <- Map.get(data, name) do
          if poke do
            usage = poke["usage"]["real"] |> Float.round(2)
            items = poke["items"] |> Enum.sort_by(fn {_k, v} -> -v end) |> Enum.take(3) |> Enum.map(fn {i, _} -> i end)
            moves = poke["moves"] |> Enum.sort_by(fn {_k, v} -> -v end) |> Enum.take(4) |> Enum.map(fn {m, _} -> m end)
            abilities = poke["abilities"] |> Enum.sort_by(fn {_k, v} -> -v end) |> Enum.take(2) |> Enum.map(fn {a, _} -> a end)

            """
            📊 Uso: #{usage}%
            🎒 Itens mais usados: #{Enum.join(items, ", ")}
            💥 Moves mais usados: #{Enum.join(moves, ", ")}
            🧬 Habilidades usadas: #{Enum.join(abilities, ", ")}
            """
          else
            "Sem dados competitivos disponíveis para #{name}."
          end

        else
          _ -> "Sem dados competitivos disponíveis."
        end

      _ ->
        "Erro ao consultar dados competitivos."
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
