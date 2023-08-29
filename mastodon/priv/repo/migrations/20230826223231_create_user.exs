defmodule Mastodon.Repo.Migrations.CreateUser do
  use Ecto.Migration


  def change do
    create table(:users) do
      add(:user_name, :string, null: false)
      add(:followers, :integer)
      add(:following, :integer)
      add(:avatar, :string)
      add(:user_id, :string, null: false)
      add(:note, :string)
    end

    create(unique_index(:users, [:user_name]))
  end
end
