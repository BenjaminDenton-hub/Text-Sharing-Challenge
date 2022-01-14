defmodule TextSharing do
  require Logger

  alias TextSharing.DataStore

  def new_share(shared_text) do
    today = DateTime.utc_now()
    text_id = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>

    text_map = %{
      current_text: shared_text,
      created: today,
      revision_history: %{
        "1" => %{
          updated_time: today,
          updated_text: shared_text
        }
      }
    }

    DataStore.add_new_text(text_id, text_map)
    # add url return with text_id
    "localhost:4001/#{text_id}"
  end

  def get_text(text_id) do
    {:ok, text_map} = DataStore.get_text(text_id)
    text_map
  end

  def update_text(text_id, new_text) do
    %{current_text: _old_text, revision_history: revision_history, created: created} =
      get_text(text_id)

    revision_count = Enum.count(revision_history)

    new_revision =
      Map.put_new(revision_history, "#{revision_count + 1}", %{
        updated_time: DateTime.utc_now(),
        updated_text: new_text
      })

    DataStore.update_text(text_id, %{
      current_text: new_text,
      revision_history: new_revision,
      created: created
    })
  end
end
