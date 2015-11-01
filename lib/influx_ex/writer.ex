defmodule InfluxEx.Writer do
  alias InfluxEx.Connection

  @spec write(map | list(map), String.t, map) :: :ok | {:error, String.t}
  def write(data, db_name, config) when is_list(data) do
    data
    |> Enum.map(&string_for_point/1)
    |> Enum.join("\n")
    |> Connection.write(db_name, config)
  end
  def write(data, db_name, config) do
    string_for_point(data)
    |> Connection.write(db_name, config)
  end


  @spec string_for_point(map) :: String.t
  defp string_for_point(data = %{measurement: measurement, fields: fields}) do
    tags = data[:tags] || %{}
    time = data[:time]

    fields_string = Enum.map(fields, fn {key, val} -> "#{key}=#{val}" end)
    |> Enum.join(",")

    tags_strings = Enum.map(tags, fn {key, val} -> "#{key}=#{val}" end)

    key = Enum.join([measurement | tags_strings], ",")

    "#{key} #{fields_string} #{time}"
    |> String.strip
  end
end
