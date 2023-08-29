import Config

config :mastodon, Mastodon.Repo,
  database: "mastodon_bayernwahl2023.db",
  journal_mode: :delete,
  type: "sqlite"

config :mastodon, ecto_repos: [Mastodon.Repo]

config :logger, level: :debug

config :mastodon, Mastodon.Scheduler,
  jobs: [
    {"@hourly", {Mastodon.WriteToDb, :mastodon_to_db, []}},
    {"@reboot", {Mastodon.WriteToDb, :mastodon_to_db, []}}
  ]
