defmodule Mastodon.Repo.Migrations.CreateField do
  use Ecto.Migration

  def change do
    create table(:fields, primary_key: true) do
      add(:user_name, :string, null: false)
      add(:field_name, :string, null: false)
      add(:field_value, :string, null: false)
    end

    create(unique_index(:fields, [:user_name, :field_name, :field_value]))
  end
end
