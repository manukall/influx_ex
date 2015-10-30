defmodule InfluxEx.Reader do
  alias InfluxEx.Connection
  alias InfluxEx.QueryResponse

  @spec read(String.t, String.t, map) :: list({:ok, list} | {:error, String.t})
  def read(query, db_name, config) do
    %QueryResponse{results: results, status_code: 200} = %{db: db_name, q: query}
    |> Connection.query(config)

    Enum.map(results, &parse_single_query_result/1)
  end

  @spec parse_single_query_result(map) :: {:ok, list} | {:error, String.t}
  defp parse_single_query_result(result) do
    case result["error"] do
      nil -> {:ok, Enum.map(result["series"], &parse_series_result/1)}
      error -> {:error, error}
    end
  end

  @spec parse_series_result(map) :: map
  defp parse_series_result(%{"name" => name, "columns" => columns, "values" => values}) do
    %{series: name,
      points: Enum.map(values, fn point -> Enum.zip(columns, point) |> Enum.into(%{}) end)}
  end
end
