defmodule Mastodon.WriteToDb do
  def mastodon_to_db() do
    alias Mastodon.RequestByTag, as: Request
    import Ecto.Query

    posts =
      ~w[bayern bayernwahl bayernwahl2023 wahlen wahlkampf wahlumfrage wahlen23 wahlen2023 spd csu gruene  grune gruenen grunen afd freiewaehler freiewahler fw fpd linke markussoeder markussoder soeder soder hubertaiwanger aiwanger hartmann martinhagen ebnersteiner]
      |> Enum.map(fn tag -> Request.query(tag) end)
      |> List.flatten()

    Request.getUser(posts)
    |> Enum.map(fn user ->
      %Mastodon.User{}
      |> Ecto.Changeset.cast(user, [:user_name, :followers, :following, :avatar, :user_id, :note])
      |> Ecto.Changeset.validate_required([:user_id, :user_name])
      |> Ecto.Changeset.unique_constraint(:user_name)
      |> Mastodon.Repo.insert()
    end)

    Request.getToot(posts)
    |> Enum.map(fn toot ->
      query =
        from(u in Mastodon.User,
          where: u.user_name == ^toot[:user_name],
          select: u.id
        )

      toot = Map.merge(toot, %{user_id: Mastodon.Repo.one(query)})

      %Mastodon.Toot{}
      |> Ecto.Changeset.cast(toot, [:user_id, :content, :date, :toot_id, :language, :user_name])
      |> Ecto.Changeset.validate_required([:user_name, :toot_id])
      |> Ecto.Changeset.unique_constraint([:user_name, :toot_id])
      |> Mastodon.Repo.insert()
    end)

    Request.getField(posts)
    |> Enum.map(fn field ->
      query =
        from(u in Mastodon.User,
          where: u.user_name == ^field[:user_name],
          select: u.id
        )

      field = Map.merge(field, %{user_id: Mastodon.Repo.one(query)})

      %Mastodon.Field{}
      |> Ecto.Changeset.cast(field, [:user_id, :user_name, :field_name, :field_value])
      |> Ecto.Changeset.validate_required([:user_name, :field_name, :field_value])
      |> Ecto.Changeset.unique_constraint([:user_name, :field_name, :field_value])
      |> Mastodon.Repo.insert()
    end)

    Request.getTag(posts)
    |> Enum.map(fn tag ->
      query =
        from(u in Mastodon.Toot,
          where: u.toot_id == ^tag["toot_id"],
          select: u.id
        )

      tag = Map.merge(tag, %{"toot_id" => Mastodon.Repo.one(query)})

      %Mastodon.Tag{}
      |> Ecto.Changeset.cast(tag, [:toot_id, :tag])
      |> Ecto.Changeset.validate_required([:toot_id, :tag])
      |> Ecto.Changeset.unique_constraint([:toot_id, :tag])
      |> Mastodon.Repo.insert()
    end)
  end
end
