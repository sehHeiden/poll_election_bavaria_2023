defmodule Mastodon.User do
  use Ecto.Schema

  schema "users" do
    field(:user_name, :string)
    field(:followers, :integer)
    field(:following, :integer)
    field(:avatar, :string)
    field(:user_id, :string)
    field(:note, :string)

    has_many(:toots, Mastodon.Toot)
    has_many(:fields, Mastodon.Field)
  end
end
