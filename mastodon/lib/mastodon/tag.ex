defmodule Mastodon.Tag do
  use Ecto.Schema

  schema "tags" do
    field(:toot_id, :string)
    field(:tag, :string)

    belongs_to(:toots, Mastodon.Toot)
  end
end
