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

  def build_from_many(filenames) when not is_list(filenames),
    do: {:error, "Please provide a list"}

  def build_from_many(filenames) do
    result =
      filenames
      # fn filename -> build(filename end)
      |> Task.async_stream(&build/1)
      |> Enum.reduce(report_acc(), fn {:ok, result}, report ->
        sum_reports(report, result)
      end)

    {:ok, result}
  end

  # Captura o maior valor do map
  # Guards
  def fetch_higher_cost(report, option) when option in @options do
    {key, cost} = Enum.max_by(report[option], fn {_key, value} -> value end)

    {:ok, %{id: key, value: cost}}
  end

  def fetch_higher_cost(_report, option),
    do: {:error, "Unhandled option error: #{option} does not exist in type @foods"}

  defp sum_reports(%{"foods" => foods1, "users" => users1}, %{
         "foods" => foods2,
         "users" => users2
       }) do
    foods = merge_maps(foods1, foods2)
    users = merge_maps(users1, users2)

    build_report(foods, users)
  end

  defp merge_maps(map1, map2),
    do: Map.merge(map1, map2, fn _key, value1, value2 -> value1 + value2 end)

  defp sum_values([id, food_name, price], %{"foods" => foods, "users" => users}) do
    users = Map.put(users, id, users[id] + price)
    foods = Map.put(foods, food_name, foods[food_name] + 1)

    # Pipe aqui serve para atualizar o Map
    build_report(foods, users)
  end

  # Pega uma coleção e converte em outra
  def report_acc do
    foods = Enum.into(@available_foods, %{}, &{&1, 0})
    users = Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})

    build_report(foods, users)
  end

  defp build_report(foods, users), do: %{"users" => users, "foods" => foods}
end
