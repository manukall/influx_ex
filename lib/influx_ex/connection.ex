defmodule InfluxEx.Connection do
  alias InfluxEx.QueryResponse

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @opt_app opts[:otp_app]

      def config do
        Application.get_env(@opt_app, __MODULE__)
      end

      def create_db(db_name) do
        InfluxEx.Connection.create_db(db_name, config)
      end

      def drop_db(db_name) do
        InfluxEx.Connection.drop_db(db_name, config)
      end

    end
  end


  def create_db(name, config) do
    URI.encode_query(%{q: "CREATE DATABASE #{name}"})
    |> query(config)
    |> ok_or_error_for_single_result
  end

  def drop_db(name, config) do
    URI.encode_query(%{q: "DROP DATABASE #{name}"})
    |> query(config)
    |> ok_or_error_for_single_result
  end

  def query(string, config) do
    url = config[:base_url] <> "/query?#{string}"
    HTTPoison.get!(url)
    |> QueryResponse.parse
  end

  defp ok_or_error_for_single_result(%QueryResponse{results: [result]}) do
    case result["error"] do
      nil -> :ok
      error -> {:error, error}
    end
  end
end
