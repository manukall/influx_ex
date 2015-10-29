defmodule InfluxEx.ConnectionTest do
  use ExUnit.Case
  doctest InfluxEx.Connection

  @db_name "influx_ex_test_db"

  test "create_db" do
    TestConnection.drop_db(@db_name)
   :ok = TestConnection.create_db(@db_name)
   {:error, "database already exists"} = TestConnection.create_db(@db_name)
  end

  test "drop_db" do
    TestConnection.drop_db(@db_name)
    :ok = TestConnection.create_db(@db_name)

    :ok = TestConnection.drop_db(@db_name)
    {:error, "database not found: influx_ex_test_db"} = TestConnection.drop_db(@db_name)
  end
end
