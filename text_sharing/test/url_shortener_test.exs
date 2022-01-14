defmodule TextSharingTest do
  use ExUnit.Case
  doctest TextSharing

  test "greets the world" do
    assert TextSharing.hello() == :world
  end
end
