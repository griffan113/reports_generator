defmodule ReportsGenerator do
  def build(filename) do
    "reports/#{filename}"
    |> ReportsGenerator.Parser.parse_file()
    |> Enum.reduce(report_acc(), fn [id, _foodName, price], report ->
      Map.put(report, id, report[id] + price)
    end)
  end

  # Pega uma coleção e converte em outra
  defp report_acc, do: Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})
end
