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
    {:error, "database not found: #{@db_name}"} = TestConnection.drop_db(@db_name)
  end

  test "write" do
    TestConnection.drop_db(@db_name)
    TestConnection.create_db(@db_name)
    :ok = TestConnection.write(%{measurement: "cpu",
                                 fields: %{load: 0.12},
                                 tags: %{host: "web-staging"}},
                               @db_name)

    :ok = TestConnection.write(%{measurement: "cpu",
                                 fields: %{load: 0.12}},
                               @db_name)

    :ok = TestConnection.write(%{measurement: "cpu",
                                 fields: %{load: 0.12},
                                 tags: %{host: "web-staging"},
                                 time: 12345678},
                               @db_name)
  end

  test "read" do
    TestConnection.drop_db(@db_name)

    [{:error, "database not found: #{@db_name}"}] = TestConnection.read("SELECT * FROM cpu", @db_name)

    TestConnection.create_db(@db_name)
    :ok = TestConnection.write(%{measurement: "cpu",
                                 fields: %{load: 0 + 0.12},
                                 tags: %{host: "web-staging"},
                                 time: 12345678},
                               @db_name)


    [{:ok, results}] = TestConnection.read("SELECT * FROM cpu", @db_name)

    assert results == [%{series: "cpu",
                             points: [
                               %{"time" => "1970-01-01T00:00:00.012345678Z",
                                 "load" => 0.12,
                                 "host" => "web-staging"}
                             ]}]
  end
end
