defmodule ReportsGenerator do
  alias ReportsGenerator.Parser

  # const
  @available_foods [
    "açai",
    "churrasco",
    "hambúrguer",
    "pastel",
    "pizza",
    "prato_feito",
    "sushi"
  ]

  def build(filename) do
    "reports/#{filename}"
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report -> sum_values(line, report) end)
  end

  # Captura o maior valor do map
  def fetch_higher_cost(report) do
    {key, cost} = Enum.max_by(report, fn {_key, value} -> value end)
    %{id: key, value: cost}
  end

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
