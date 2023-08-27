import Config

config :mastodon, Mastodon.Repo,
  database: "mastodon_repos.db",
  type: "sqlite"

config :mastodon, ecto_repos: [Mastodon.Repo]

config :mastodon, Mastodon.Scheduler,
  jobs: [
    {"@daily", {Backup, :backup, []}},
    {"@hourly", {Mastodon.WriteDb, :mastodon, []}},
    {"@reboot", {Mastodon.WriteDb, :mastodon, []}}
  ]
