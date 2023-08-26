defmodule Mastodon.Repo.Migrations.CreateToot do
  use Ecto.Migration

  create table(:toots) do
      add(:user_name, :string, null: false)
      add(:toot_id, :string, null: false, primary_key: true)
      add(:content, :string)
      add(:date, :date)
      add(:language, :string, default: "de")
    end

    create(unique_index(:toots, [:user_name, :toot_id]))
end
