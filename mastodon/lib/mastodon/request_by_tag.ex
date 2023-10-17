defmodule Mastodon.RequestByTag do
  @moduledoc """
  Fetch Mastodon posts by tag and partion it.
  """

  @doc """

  Get all a posts from a:

  ## ParameterizedType
   - tag: String 

  """
  @spec query(String.t()) :: List.t()
  def query(tag) do
    response = HTTPoison.get!("https://chaos.social/api/v1/timelines/tag/#{tag}?limit=40")
    Jason.decode!(response.body)
  end

  @spec search(String.t(), String.t()) :: List.t()
  def search(query, access_token) do
    headers = [Authorization: "Bearer #{access_token}"]

    response =
      HTTPoison.get!(
        "https://chaos.social/api/v2/search?q=#{query}&type=statuses&limit=40&resolve=true",
        headers
      )

    Jason.decode!(response.body)["statuses"]
  end

  @spec getToot(List.t()) :: List.t()
  def getToot(posts) do
    Enum.map(posts, fn post ->
      %{
        user_name: post["account"]["acct"],
        toot_id: post["id"],
        content: post["content"],
        date: post["created_at"],
        language: post["language"]
      }
    end)
  end

  @spec getUser(List.t()) :: List.t()
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

  @spec getField(List.t()) :: List.t()
  def getField(posts) do
    Enum.map(posts, fn post ->
      fields = post["account"]["fields"]

      Enum.map(fields, fn field ->
        %{
          user_name: post["account"]["acct"],
          field_name: field["name"],
          field_value: field["value"]
        }
      end)
    end)
    |> List.flatten()
  end

  @spec getTag(List.t()) :: List.t()
  def getTag(posts) do
    Enum.map(posts, fn post ->
      tags = post["tags"]

      Enum.map(tags, fn tag ->
        tootid = post["id"]

        %{
          "toot_id" => tootid,
          "tag" => if(tag, do: tag["name"], else: nil)
        }
      end)
    end)
    |> List.flatten()
  end
end
