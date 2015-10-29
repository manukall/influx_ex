# InfluxEx

InfluxDB interface for elixir

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add influx_ex to your list of dependencies in `mix.exs`:

        def deps do
          [{:influx_ex, "~> 0.0.1"}]
        end

  2. Ensure influx_ex is started before your application:

        def application do
          [applications: [:influx_ex]]
        end

## Setup
### Define a connection module:

    defmodule MyApp.InfluxConnection do
      use InfluxEx.Connection, otp_app: :my_app
    end

### Configure your connection module:
In `config.exs` (or `dev.exs` or `test.exs`...)

    config :my_app, InfluxConnection
      base_url: "http://localhost:8086"


## Usage
### Manage databases:
#### Create a database:

    TestConnection.create_db("my_db")

#### Drop a database:

    TestConnection.drop_db("my_db")
