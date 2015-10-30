defmodule InfluxEx.Writer do
  alias InfluxEx.Connection

  def write(data = %{measurement: measurement, fields: fields}, db_name, config) do
    tags = data[:tags] || %{}
    time = data[:time]

    fields_string = Enum.map(fields, fn {key, val} -> "#{key}=#{val}" end)
    |> Enum.join(",")

    tags_strings = Enum.map(tags, fn {key, val} -> "#{key}=#{val}" end)

    key = Enum.join([measurement | tags_strings], ",")

    "#{key} #{fields_string} #{time}"
    |> String.strip
    |> Connection.write(db_name, config)
  end
end
