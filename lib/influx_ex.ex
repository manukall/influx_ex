defmodule InfluxEx do
  @moduledoc ~S"""
    InfluxDB interface for elixir

## Setup:

    Define a connection module:

      defmodule MyApp.InfluxConnection do
        use InfluxEx.Connection, otp_app: :my_app
      end

    Configure your connection module:
    In `config.exs` (or `dev.exs` or `test.exs`...)

      config :my_app, InfluxConnection,
        base_url: "http://localhost:8086"
  """
end
