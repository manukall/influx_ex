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

    config :my_app, InfluxConnection,
      base_url: "http://localhost:8086"


## Usage

### Manage databases:
#### Creating a database:

    MyApp.InfluxConnection.create_db("my_db")

See `InfluxEx.Connection` for details.

#### Droping a database:

    MyApp.InfluxConnection.drop_db("my_db")

See `InfluxEx.Connection` for details.

### Writing data:

    :ok = MyApp.InfluxConnection.write(%{measurement: "cpu",
                                 fields: %{load: 0.12},
                                 tags: %{host: "web-staging"},
                                 time: 12345678},
                               "my_db")

You can also write a list of points in a single query:

    points = for i <- 1..2 do
      %{measurement: "cpu",
        fields: %{load: i + 0.12},
        time: i + 12345670}
    end
    :ok = MyApp.InfluxConnection.write(points, "my_db")

See `InfluxEx.Connection` for details.


### Reading data:

    MyApp.InfluxConnection.read("SELECT * FROM cpu", "my_db")
    [ok: [
    %{series: "cpu",
      points: [
        %{"host" => "web-staging", "load" => 0.12,
        "time" => "2015-11-01T14:26:25.73642475Z"}
      ]}
    ]]

Because you can potentially run multiple queries in one request, you will get a list
back from `InfluxConnection.read`. This list consists of a `{:ok, results}` or
`{:error, message}` tuple for each query.
`results` in turn consists of a list of points per series.
