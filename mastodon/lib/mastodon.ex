defmodule Mastodon do
  @moduledoc """
  Documentation for `Mastodon`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Mastodon.hello()
      :world

  """
  def hello do
    :world
  end

  def mastodonToDB() do
    alias Mastodon.RequestByTag, as: Request

    posts = ~w[bayern bayernwahl bayernwahl2023 wahlen wahlkampf wahlumfrage wahlen23 wahlen2023 spd csu gruene  grune gruenen grunen afd freiewaehler freiewahler fw fpd linke markussoeder markussoder soeder soder hubertaiwanger aiwanger hartmann martinhagen ebnersteiner]
      |> Enum.map(fn tag -> Request.query(tag) end)
      |> List.flatten()

    Request.getToot(posts)
    |> Enum.map(fn toot ->
      %Mastodon.Toot{}
      |> Ecto.Changeset.cast(toot, [:content, :date, :toot_id, :language, :user_name])
      |> Ecto.Changeset.validate_required([:user_name, :toot_id])
      |> Ecto.Changeset.unique_constraint([:user_name, :toot_id])
      |> Mastodon.Repo.insert()
    end)

    Request.getUser(posts)
    |> Enum.map(fn user ->
      %Mastodon.User{}
      |> Ecto.Changeset.cast(user, [:user_name, :followers, :following, :avatar, :user_id, :note])
      |> Ecto.Changeset.validate_required([:user_id, :user_name])
      |> Ecto.Changeset.unique_constraint(:user_name)
      |> Mastodon.Repo.insert()
    end)

    Request.getField(posts)
    |> Enum.map(fn field ->
      %Mastodon.Field{}
      |> Ecto.Changeset.cast(field, [:user_name, :field_name, :field_value])
      |> Ecto.Changeset.validate_required([:user_name, :field_name, :field_value])
      |> Ecto.Changeset.unique_constraint([:user_name, :field_name, :field_value])
      |> Mastodon.Repo.insert()
    end)

    Request.getTag(posts)
    |> Enum.map(fn tag ->
      %Mastodon.Tag{}
      |> Ecto.Changeset.cast(tag, [:toot_id, :tag])
      |> Ecto.Changeset.validate_required([:toot_id, :tag])
      |> Ecto.Changeset.unique_constraint([:toot_id, :tag])
      |> Mastodon.Repo.insert()
    end)
  end
end
