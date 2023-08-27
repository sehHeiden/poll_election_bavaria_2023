defmodule Mastodon.Toot do
  use Ecto.Schema

  schema "toots" do
    field(:user_name, :string)
    field(:toot_id, :string)
    field(:content, :string)
    field(:date, :utc_datetime)
    field(:language, :string, default: "de")

    has_many(:tags, Mastodon.Tag)
    belongs_to(:users, Mastodon.User)
  end
end
