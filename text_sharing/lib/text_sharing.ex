defmodule TextSharing do
  require Logger

  alias TextSharing.DataStore

  def shorten(long_url) do
    case DataStore.exists?(long_url) do
      true ->
        {:ok, old_short_url} = DataStore.get_short_url(long_url)
        old_short_url

      _ ->
        short_token = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>
        short_url = "localhost:4001/" <> short_token
        Logger.info("Shortened " <> long_url <> " to " <> short_url <> "!")
        DataStore.add_new_url(long_url, short_url)
        short_url
    end
  end

  def get_url(short_token) do
    DataStore.get_long_url("localhost:4001/" <> short_token)
  end
end
