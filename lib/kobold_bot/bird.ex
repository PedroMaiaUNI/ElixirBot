defmodule WeavBot.Bird do

  def handle_bird_command do

    case Finch.build(:get, "https://some-random-api.com/animal/bird")
      |> Finch.request(MyFinch) do
        {:ok, response} when response.status == 200 ->
          {:ok, json} = JSON.decode(response.body)
          image = json["image"]
          fact = json["fact"]

          "**DID YOU KNOW?**: #{fact} \n #{image}"

      _ -> "Erro ao buscar dados"

      end
  end

end
