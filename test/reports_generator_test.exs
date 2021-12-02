defmodule ReportsGeneratorTest do
  use ExUnit.Case

  describe "build/1" do
    test "Builds the report" do
      file_name = "report_test.csv"

      response =
        file_name
        |> ReportsGenerator.build()

      expected_response = %{
        "foods" => %{
          "acai" => 1,
          "churrasco" => 2,
          "esfirra" => 3,
          "hamburguer" => 2,
          "pastel" => 0,
          "pizza" => 2,
          "prato_feito" => 0,
          "sushi" => 0
        },
        "users" => %{
          "1" => 48,
          "10" => 36,
          "11" => 0,
          "12" => 0,
          "13" => 0,
          "14" => 0,
          "15" => 0,
          "16" => 0,
          "17" => 0,
          "18" => 0,
          "19" => 0,
          "2" => 45,
          "20" => 0,
          "21" => 0,
          "22" => 0,
          "23" => 0,
          "24" => 0,
          "25" => 0,
          "26" => 0,
          "27" => 0,
          "28" => 0,
          "29" => 0,
          "3" => 31,
          "30" => 0,
          "4" => 42,
          "5" => 49,
          "6" => 18,
          "7" => 27,
          "8" => 25,
          "9" => 24
        }
      }

      assert response == expected_response
    end
  end

  describe "build_from_many/1" do
    test "When a file list is provided builds the report" do
      file_names = ["report_test.csv", "report_test.csv"]

      response =
        file_names
        |> ReportsGenerator.build_from_many()

      expected_response =
        {:ok,
         %{
           "foods" => %{
             "acai" => 2,
             "churrasco" => 4,
             "esfirra" => 6,
             "hamburguer" => 4,
             "pastel" => 0,
             "pizza" => 4,
             "prato_feito" => 0,
             "sushi" => 0
           },
           "users" => %{
             "1" => 96,
             "10" => 72,
             "11" => 0,
             "12" => 0,
             "13" => 0,
             "14" => 0,
             "15" => 0,
             "16" => 0,
             "17" => 0,
             "18" => 0,
             "19" => 0,
             "2" => 90,
             "20" => 0,
             "21" => 0,
             "22" => 0,
             "23" => 0,
             "24" => 0,
             "25" => 0,
             "26" => 0,
             "27" => 0,
             "28" => 0,
             "29" => 0,
             "3" => 62,
             "30" => 0,
             "4" => 84,
             "5" => 98,
             "6" => 36,
             "7" => 54,
             "8" => 50,
             "9" => 48
           }
         }}

      assert response == expected_response
    end

    test "when a file list is not provided, returns an error" do
      file_names = "not-list"

      response =
        file_names
        |> ReportsGenerator.build_from_many()

      expected_response = {:error, "Please provide a list"}

      assert response == expected_response
    end
  end

  describe "fetch_higher_cost/2" do
    test "when the option is 'users', returns the user who spend the most" do
      file_name = "report_test.csv"

      response =
        file_name
        |> ReportsGenerator.build()
        |> ReportsGenerator.fetch_higher_cost("users")

      expected_response = {:ok, %{id: "5", value: 49}}

      assert response == expected_response
    end

    test "when the option is 'food', returns the most appeared food" do
      file_name = "report_test.csv"

      response =
        file_name
        |> ReportsGenerator.build()
        |> ReportsGenerator.fetch_higher_cost("foods")

      expected_response = {:ok, %{id: "esfirra", value: 3}}

      assert response == expected_response
    end

    test "when an invalid option is provided, returns an error" do
      file_name = "report_test.csv"

      response =
        file_name
        |> ReportsGenerator.build()
        |> ReportsGenerator.fetch_higher_cost("invalid_option")

      expected_response =
        {:error, "Unhandled option error: invalid_option does not exist in type @foods"}

      assert response == expected_response
    end
  end
end
