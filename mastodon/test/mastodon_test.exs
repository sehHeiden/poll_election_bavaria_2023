defmodule MastodonTest do
  use ExUnit.Case
  doctest Mastodon

  test "greets the world" do
    assert Mastodon.hello() == :world
  end
end
