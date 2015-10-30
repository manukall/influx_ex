defmodule InfluxEx.WriteResponse do
  @moduledoc """
  Defines the response of a request to the /write endpoint.
  """

  defstruct status_code: nil, results: []

  @type t :: %__MODULE__{status_code: integer, results: []}

  @doc """
  Parses the httpoison response of a request to the /query endpoint and returns a QueryResponse struct.
  """
  @spec parse(HTTPoison.Response.t) :: :ok | {:error, String.t}
  def parse(%HTTPoison.Response{status_code: 204}), do: :ok
  def parse(%HTTPoison.Response{body: error_message}), do: {:error, error_message}

end
