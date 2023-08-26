defmodule Mastodon.RequestByTag do
  def query(tag) do
    response = HTTPoison.get!("https://chaos.social/api/v1/timelines/tag/#{tag}")
    Jason.decode!(response.body)
  end

  def getToot(posts) do
    Enum.map(posts, fn post ->
      %{
        user_name: post["account"]["acct"],
        id: post["id"],
        content: post["content"],
        date: post["created_at"],
        language: post["language"]
      }
    end)
  end

  def getUser(posts) do
    Enum.map(posts, fn post ->
      %{
        user_name: post["account"]["acct"],
        followers: post["account"]["followers_count"],
        following: post["account"]["following_count"],
        avatar: post["account"]["avatar"],
        user_id: post["account"]["id"],
        note: post["account"]["note"]
      }
    end)
  end

  def getField(posts) do
    Enum.map(posts, fn post ->
      fields = post["account"]["fields"]

      Enum.map(fields, fn field ->
        %{
          user_name: post["account"]["user"],
          field_name: field["name"],
          field_value: field["value"]
        }
      end)
    end)
    |> List.flatten()
  end

  def getTag(posts) do
    Enum.map(posts, fn post ->
      tags = post["tags"]

      Enum.map(tags, fn tag ->
        tootid = post["id"]

        %{
          "tootid" => tootid,
          "tag" => if(tag, do: tag["name"], else: nil)
        }
      end)
    end)
    |> List.flatten()
  end
end
