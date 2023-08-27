defmodule Mastodon.Field do
  use Ecto.Schema

  schema "fields" do
    field(:user_name, :string)
    field(:field_name, :string)
    field(:field_value, :string)

    belongs_to(:users, Mastodon.User)
  end
end
