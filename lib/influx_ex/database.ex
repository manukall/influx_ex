defmodule InfluxEx.Database do
  alias InfluxEx.Connection
  alias InfluxEx.QueryResponse

  @moduledoc """
  Responsible for database management queries.

  Functions of this module will usually be called through the connection module.
  """

  @doc false
  @spec create_db(String.t, map) :: :ok | {:error, String.t}
  def create_db(name, config) do
    %{q: "CREATE DATABASE #{name}"}
    |> Connection.query(config)
    |> ok_or_error_for_single_result
  end

  @doc false
  @spec drop_db(String.t, map) :: :ok | {:error, String.t}
  def drop_db(name, config) do
    %{q: "DROP DATABASE #{name}"}
    |> Connection.query(config)
    |> ok_or_error_for_single_result
  end


  @spec ok_or_error_for_single_result(QueryResponse.t) :: :ok | {:error, String.t}
  defp ok_or_error_for_single_result(%QueryResponse{results: [result]}) do
    case result["error"] do
      nil -> :ok
      error -> {:error, error}
    end
  end
end
