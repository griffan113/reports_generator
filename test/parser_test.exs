defmodule ReportsGenerator.ParserTest do
  use ExUnit.Case

  alias ReportsGenerator.Parser

  describe "parse_file/1" do
    test "Parses the file" do
      file_name = "report_test.csv"

      response =
        file_name
        |> Parser.parse_file()
        |> Enum.map(& &1)

      # & Chama um função anônima, &1 pega o primeiro parâmetro dessa função
      # Pega cada elemento que o map passa, e retorna uma lista de listas

      expected_response = [
        ["1", "pizza", 48],
        ["2", "acai", 45],
        ["3", "hamburguer", 31],
        ["4", "esfirra", 42],
        ["5", "hamburguer", 49],
        ["6", "esfirra", 18],
        ["7", "pizza", 27],
        ["8", "esfirra", 25],
        ["9", "churrasco", 24],
        ["10", "churrasco", 36]
      ]

      assert response == expected_response
    end
  end
end
