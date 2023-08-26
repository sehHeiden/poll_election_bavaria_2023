defmodule Mastodon.Repo do
  use Ecto.Repo,
    otp_app: :mastodon,
    adapter: Ecto.Adapters.SQLite3
end
