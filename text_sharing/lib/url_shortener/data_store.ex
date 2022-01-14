defmodule TextSharing.DataStore do
  use GenServer

  @name DStore

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: DStore])
  end

  def exists?(long_url) do
    GenServer.call(@name, {:exists?, long_url})
  end

  def get_short_url(long_url) do
    GenServer.call(@name, {:get_short_url, long_url})
  end

  def get_long_url(short_url) do
    GenServer.call(@name, {:get_long_url, short_url})
  end

  def add_new_url(long_url, short_url) do
    GenServer.cast(@name, {:add_new_url, long_url, short_url})
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:exists?, long_url}, _from, state) do
    {:reply, Map.has_key?(state, long_url), state}
  end

  def handle_call({:get_short_url, long_url}, _from, state) do
    {:reply, Map.fetch(state, long_url), state}
  end

  def handle_call({:get_long_url, short_url}, _from, state) do
    [long_url] =
      Enum.map(
        state,
        fn {map_long_url, map_short_url} ->
          if(map_short_url == short_url) do
            map_long_url
          end
        end
      )

    {:reply, long_url, state}
  end

  def handle_cast({:add_new_url, long_url, short_url}, state) do
    {:noreply, Map.put(state, long_url, short_url)}
  end
end
