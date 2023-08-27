defmodule Mastodon.MixProject do
  use Mix.Project

  def project do
    [
      app: :mastodon,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Mastodon.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:ecto_sqlite3, "~> 0.10"},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.4"},
      {:quantum, "~> 3.0"}
    ]
  end
end
