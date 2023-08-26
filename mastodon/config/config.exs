import Config

config :mastodon, Mastodon.Repo,
  database: "mastodon_repos.db",
  type: "sqlite"

config :mastodon, ecto_repos: [Mastodon.Repo]
