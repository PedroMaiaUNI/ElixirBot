defmodule KoboldBot.Anilist do
  @endpoint "https://graphql.anilist.co"

  def handle_anilist_command(msg) do
    parts = String.split(msg.content, " ", trim: true)
    type = Enum.at(parts, 1)
    query = Enum.drop(parts, 2) |> Enum.join(" ")

    cond do
      is_nil(type) or query == "" -> "Uso: `!anilist <type> <query>`. Ex: anilist anime gintama"

      true ->
        case String.downcase(type) do
          "anime" -> search_media("ANIME", query)
          "manga" -> search_media("MANGA", query)
          "character" -> search_character(query)
          "staff" -> search_staff(query)
          "studio" -> search_studio(query)
          _ -> "Tipo inválido. Tente [anime, manga, character, staff, studio]"
        end
    end
  end

  defp search_media(type, query) do
    gql_query =
    """
    query ($search: String, $type: MediaType) {
      Media(search: $search, type: $type) {
        id
        title {
          romaji
          english
        }
        description(asHtml: false)
        startDate {
          year
        }
        format
        averageScore
        episodes
        chapters
        volumes
        siteUrl
      }
    }
    """

    variables = %{search: query, type: type}

    with {:ok, res} <- graphql_request(gql_query, variables),
         {:ok, %{"data" => %{"Media" => media}}} <- JSON.decode(res.body) do
      title = media["title"]["english"] || media["title"]["romaji"]
      desc = clean_description(media["description"])
      year = media["startDate"]["year"] || "Desconhecido"
      format = media["format"] || "N/A"
      url = media["siteUrl"]
      avgScore = media["averageScore"]
      lenght =
              if type == "ANIME" do
                eps = media["episodes"] || "?"
                "🎬 Episódios: #{eps}"
              else
                ch = media["chapters"] || "?"
                vol = media["volumes"] || "?"
                "📖 Capítulos: #{ch} | Volumes: #{vol}"
              end

      """
      **#{title}**
      📅 Ano: #{year}
      🎞️ Formato: #{format}
      📊 Nota Média: #{avgScore}
      #{lenght}

      #{desc}

      🔗 [Ver no AniList](#{url})
      """
    else
      _ -> "Não foi possível encontrar o #{String.downcase(type)} com o nome '#{query}'."
    end
  end

  defp search_character(query) do
    gql_query = """
    query ($search: String) {
      Character(search: $search) {
        id
        name {
          full
        }
        image {
          large
        }
        description
        siteUrl
      }
    }
    """

    variables = %{search: query}

    with {:ok, res} <- graphql_request(gql_query, variables),
         {:ok, %{"data" => %{"Character" => char}}} <- JSON.decode(res.body) do
      name = char["name"]["full"]
      desc = clean_description(char["description"])
      image = char["image"]["large"]
      url = char["siteUrl"]

      """
      **#{name}**
      👤 Personagem
      🖼️ #{image}

      #{desc}

      🔗 [Ver no AniList](#{url})
      """
    else
      _ -> "Personagem não encontrado."
    end
  end

  defp search_staff(query) do
    gql_query = """
    query ($search: String) {
      Staff(search: $search) {
        id
        name {
          full
        }
        languageV2
        image {
          large
        }
        description
        siteUrl
      }
    }
    """

    variables = %{search: query}

    with {:ok, res} <- graphql_request(gql_query, variables),
         {:ok, %{"data" => %{"Staff" => staff}}} <- JSON.decode(res.body) do
      name = staff["name"]["full"]
      lang = staff["languageV2"] || "Desconhecido"
      desc = clean_description(staff["description"])
      image = staff["image"]["large"]
      url = staff["siteUrl"]

      """
      **#{name}**
      🗣️ Idioma: #{lang}
      🖼️ #{image}

      #{desc}

      🔗 [Ver no AniList](#{url})
      """
    else
      _ -> "Staff não encontrado."
    end
  end

  defp search_studio(query) do
    gql_query = """
    query ($search: String) {
      Studio(search: $search) {
        id
        name
        siteUrl
        isAnimationStudio
      }
    }
    """

    variables = %{search: query}

    with {:ok, res} <- graphql_request(gql_query, variables),
         {:ok, %{"data" => %{"Studio" => studio}}} <- JSON.decode(res.body) do
      name = studio["name"]
      anim = if studio["isAnimationStudio"], do: "🎬 Estúdio de animação", else: "🏢 Produtora"
      url = studio["siteUrl"]

      """
      **#{name}**
      #{anim}

      🔗 [Ver no AniList](#{url})
      """
    else
      _ -> "Estúdio não encontrado."
    end
  end

  defp graphql_request(query, variables) do
    headers = [{"Content-Type", "application/json"}]
    body = JSON.encode!(%{query: query, variables: variables})
    Finch.build(:post, @endpoint, headers, body) |> Finch.request(MyFinch)
  end

  defp clean_description(nil), do: "Sem descrição disponível."
  defp clean_description(desc) do
    desc
    |> String.replace(~r/<[^>]*>/, "") # remove tags HTML
    |> String.replace(~r/\s+/, " ")
    |> String.trim()
    |> String.slice(0, 400)
  end

end
