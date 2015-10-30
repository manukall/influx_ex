defmodule InfluxEx.Connection do
  alias InfluxEx.QueryResponse
  alias InfluxEx.WriteResponse

  @moduledoc """
  Use in a module to define a connection:

      defmodule MyApp.InfluxConnection do
        use InfluxEx.Connection, otp_app: :my_app
      end
  """


  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @behaviour InfluxEx.Connection

      @opt_app opts[:otp_app]

      def create_db(db_name) do
        InfluxEx.Database.create_db(db_name, config)
      end

      def drop_db(db_name) do
        InfluxEx.Database.drop_db(db_name, config)
      end

      def write(data, db_name) do
        InfluxEx.Writer.write(data, db_name, config)
      end

      def read(query, db_name) do
        InfluxEx.Reader.read(query, db_name, config)
      end



      @spec config() :: map
      defp config do
        Application.get_env(@opt_app, __MODULE__)
      end

    end
  end


  @doc """
  Creates a database.

  Returns either `:ok` in case of success
  or `{:error, "error message"}` in case of errors.
  """
  @callback create_db(String.t) :: :ok | {:error, String.t}


  @doc """
  Drops a database.

  Returns either `:ok` in case of success
  or `{:error, "error message"}` in case of errors.
  """
  @callback drop_db(String.t) :: :ok | {:error, String.t}


  @doc """
  Writes a point to the database.

  A point is a map of the form

      %{measurement: "cpu",
        fields: %{load: 0.12},
        tags: %{host: "web-staging"},
        time: 12345678}

  `measurement` and `fields` have to be present, `tags` and `time` can be omitted.

  Returns either `:ok` in case of success
  or `{:error, "error message"}` in case of errors.
  """
  @callback write(map, String.t) :: :ok | {:error, String.t}


  @doc """
  Run one or more read queries against the database.

  Returns a list of `{:ok, results}` and `{:error, message}` tuples, one for each query.
  Inside `{:ok, results}` tuples, `results` is a list of series' with associated points.
  """
  @callback read(String.t, String.t) :: list({:ok, list} | {:error, String.t})


  @doc false
  @spec query(map, map) :: QueryResponse.t
  def query(params, config) do
    params_string = URI.encode_query(params)
    url = config[:base_url] <> "/query?#{params_string}"
    HTTPoison.get!(url)
    |> QueryResponse.parse
  end

  @doc false
  @spec write(String.t, String.t, map) :: :ok | {:error, String.t}
  def write(data, db_name, config) do
    url = config[:base_url] <> "/write?db=#{db_name}"
    HTTPoison.post!(url, data)
    |> WriteResponse.parse
  end
end
