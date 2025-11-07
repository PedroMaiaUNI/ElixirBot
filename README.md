# 🤖 Weavbot

Um bot de Discord desenvolvido em **Elixir** para a cadeira de Programação Funcional da Unifor.

---

## 🚀 Funcionalidades

O Weavbot responde a diversos comandos interativos no Discord:

| Comando | Descrição |
|----------|------------|
| 🐦 **`!bird`** | Mostra uma imagem aleatória de um pássaro e um fato curioso. |
| 🔥 **`!pokemon <nome>`** | Exibe informações detalhadas de um Pokémon, incluindo dados competitivos (via PokéAPI e Smogon). |
| 🗺️ **`!map <local>`** | Mostra informações sobre um local (usando OpenStreetMap). |
| 📚 **`!anilist <tipo> <nome>`** | Busca animes, mangás, personagens ou staff na AniList. |
| 💱 **`!money <valor> <moeda_origem> <moeda_destino>`** | Converte valores entre moedas usando a API [Frankfurter.app](https://www.frankfurter.app). |
| ❓ **`!help`** | Lista todos os comandos disponíveis. |

---

## 🧩 Tecnologias principais

- 🧠 **Elixir** — linguagem funcional moderna e concorrente  
- ⚙️ **Nostrum** — biblioteca para integração com o Discord  
- 🌍 **Finch** — HTTP client leve e eficiente  
- 🧰 **APIs utilizadas:**
  - [Bird API](https://some-random-api.ml/animal/bird)
  - [PokéAPI](https://pokeapi.co)
  - [Smogon (GitHub data)](https://github.com/pkmn/smogon)
  - [OpenStreetMap Nominatim](https://nominatim.openstreetmap.org)
  - [AniList GraphQL API](https://anilist.co/graphiql)
  - [Frankfurter.app](https://www.frankfurter.app)

---

## 🧠 Pré-requisitos

- Elixir 1.14+  
- Token de bot do Discord  
- Dependências do projeto (Finch, Nostrum, Jason, etc.)

---

## ⚙️ Instalação e execução

1. **Clone o repositório**
   ```bash
   git clone https://github.com/seuusuario/weavbot.git
   cd weavbot
