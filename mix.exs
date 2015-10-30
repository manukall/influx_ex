defmodule InfluxEx.Mixfile do
  use Mix.Project
  @github "https://github.com/manukall/influx_ex"

  def project do
    [app: :influx_ex,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     dialyzer: [plt_add_deps: true, plt_file: ".local.plt"],
     docs: docs
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison, :poison]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:httpoison, "~> 0.7.4"},
     {:poison, "~> 1.5"},
     {:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.10", only: :dev}]
  end

  def docs do
    [ extras:     [ "README.md" ],
      main:       "extra-readme",
      source_ref: "master",
      source_url: @github ]
  end
end
