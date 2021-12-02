defmodule ReportsGenerator do
  alias ReportsGenerator.Parser

  # const
  @available_foods [
    "acai",
    "churrasco",
    "hamburguer",
    "pastel",
    "esfirra",
    "pizza",
    "prato_feito",
    "sushi"
  ]

  @options [
    "foods",
    "users"
  ]

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report ->
      sum_values(line, report)
    end)
  end

  # Captura o maior valor do map
  # Guards
  def fetch_higher_cost(report, option) when option in @options do
    {key, cost} = Enum.max_by(report[option], fn {_key, value} -> value end)

    {:ok, %{id: key, value: cost}}
  end

  def fetch_higher_cost(_report, option),
    do: {:error, "Unhandled option error: #{option} does not exist in type @foods"}

  defp sum_values([id, food_name, price], %{"foods" => foods, "users" => users} = report) do
    users = Map.put(users, id, users[id] + price)
    foods = Map.put(foods, food_name, foods[food_name] + 1)

    # Pipe aqui serve para atualizar o Map
    %{report | "users" => users, "foods" => foods}
  end

  # Pega uma coleção e converte em outra
  def report_acc do
    foods = Enum.into(@available_foods, %{}, &{&1, 0})
    users = Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})

    %{"users" => users, "foods" => foods}
  end
end
