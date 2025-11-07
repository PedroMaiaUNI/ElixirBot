defmodule KoboldBot.Map do
  @nominatim_base "https://nominatim.openstreetmap.org/search"

  def handle_map_command(msg) do
    parts = String.split(msg.content, " ", trim: true)
    query = Enum.at(parts, 1)

    cond do
      is_nil(query) ->
        "Uso: `!map <nome do lugar>` (ex: `!map Lisboa` ou `!map Torre Eiffel`)"

      true ->
        url = "#{@nominatim_base}?q=#{URI.encode(query)}&format=json&limit=1"
        headers = [{"User-Agent", "WeavBot/1.0 (DiscordBot)"}]

        case Finch.build(:get, url, headers) |> Finch.request(MyFinch) do
          {:ok, %{status: 200, body: body}} ->
            with {:ok, [first | _]} <- JSON.decode(body) do
              build_response(first)
            else
              {:ok, []} -> "Nenhum resultado encontrado para `#{query}`."
              {:error, _} -> "Erro ao processar dados do OpenStreetMap."
            end

          {:ok, %{status: code}} ->
            "Erro: OpenStreetMap retornou status #{code}."

          {:error, _reason} ->
            "Erro ao conectar com o OpenStreetMap."
        end
    end
  end

  defp build_response(result) do
    display_name = result["display_name"]
    lat = result["lat"]
    lon = result["lon"]
    type = result["type"]

    map_link = "https://www.openstreetmap.org/?mlat=#{lat}&mlon=#{lon}&zoom=12"

    """
    📍 **#{display_name}**
    🗺️ Tipo: #{String.capitalize(type)}
    🌐 Latitude: #{lat}
    🌐 Longitude: #{lon}
    🔗 [Ver no OpenStreetMap](#{map_link})
    """
  end
end
