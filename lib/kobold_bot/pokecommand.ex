defmodule KoboldBot.PokeCommand do
  @endpoint "https://pokeapi.co/api/v2/pokemon/"

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
              types =
                json["types"]
                |> Enum.map(fn t -> t["type"]["name"] end)
                |> Enum.join(", ")

              image = get_in(json, ["sprites", "front_default"])
              name = String.capitalize(name)

              """
              **#{name}**
              🌀 Tipos: #{types}
              #{image}
              """
            end

          {:ok, %{status: 404}} ->
            "Pokémon não encontrado."

          {:error, _reason} ->
            "Erro ao acessar a PokéAPI."
        end
    end
  end
end
