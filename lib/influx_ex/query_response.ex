defmodule InfluxEx.QueryResponse do
  @moduledoc """
  Defines the response of a request to the /query endpoint.
  """

  defstruct status_code: nil, results: []

  @type t :: %__MODULE__{status_code: integer, results: []}

  @doc """
  Parses the httpoison response of a request to the /query endpoint and returns a QueryResponse struct.
  """
  @spec parse(HTTPoison.Response.t) :: __MODULE__.t
  def parse(%HTTPoison.Response{body: body, status_code: status_code}) do
    result = body
    |> Poison.decode!
    %__MODULE__{
      status_code: status_code,
      results: result["results"]
    }
  end

end
