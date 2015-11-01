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
  defp parse_single_query_result(%{"error" => error}), do: {:error, error}
  defp parse_single_query_result(%{"series" => series}) do
    {:ok, Enum.map(series, &parse_series_result/1)}
  end
  defp parse_single_query_result(%{}), do: {:ok, []}

  @spec parse_series_result(map) :: map
  defp parse_series_result(%{"name" => name, "columns" => columns, "values" => values}) do
    %{series: name,
      points: Enum.map(values, fn point -> Enum.zip(columns, point) |> Enum.into(%{}) end)}
  end
end
