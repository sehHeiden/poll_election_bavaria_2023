defmodule Mastodon.Repo.Migrations.CreateTag do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add(:toot_id, :string, null: false)
      add(:tag, :string, null: false)
    end

    create(unique_index(:tags, [:toot_id, :tag]))
end
