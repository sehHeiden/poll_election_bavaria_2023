defmodule Mastodon.Repo.Migrations.CreateTag do
  use Ecto.Migration

  def change do
    create table(:tags, primary_key: true) do
      add(:toot_id, :string, null: false)
      add(:tag, :string, null: false)
    end

    # create(unique_index(:tags, [:toot_id, :tag]))
    # @primary_key {:id, :binary_id, autogenerate: true}
  end
end