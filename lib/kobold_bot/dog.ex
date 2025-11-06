defmodule KoboldBot.Dog do

  def handle_dog_command do
    {:ok, response} = Finch.build(:get, "https://dog.ceo/api/breeds/image/random") |> Finch.request(MyFinch)
    {:ok, json} = JSON.decode(response.body)
    json["message"]
  end

end
