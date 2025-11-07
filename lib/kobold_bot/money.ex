defmodule KoboldBot.Money do

  @endpoint "https://api.frankfurter.app/latest"

  def handle_money_command(msg) do
    parts = String.split(msg.content, " ", trim: true)

    cond do
      length(parts) < 4 ->
        "Uso: `!money <valor> <moeda_origem> <moeda_destino>` (ex: `!money 10 USD BRL`)"

      true ->
        amount = Enum.at(parts, 1)
        from = Enum.at(parts, 2) |> String.upcase()
        to = Enum.at(parts, 3) |> String.upcase()

        url = "#{@endpoint}?amount=#{amount}&from=#{from}&to=#{to}"

        case Finch.build(:get, url) |> Finch.request(MyFinch) do
          {:ok, %{status: 200, body: body}} ->
            with {:ok, json} <- JSON.decode(body),
                 %{"rates" => rates} <- json,
                 [{currency, converted}] <- Enum.to_list(rates) do
              """
              💱 **Conversão de Moeda**
              💵 Valor original: #{amount} #{from}
              💰 Convertido: #{Float.round(converted, 2)} #{currency}
              """
            else
              _ -> "Erro ao interpretar dados da API."
            end

          {:ok, %{status: 404}} ->
            "Moeda inválida ou não suportada."

          {:error, _reason} ->
            "Erro ao conectar com a API de câmbio."
        end
    end
  end
end
