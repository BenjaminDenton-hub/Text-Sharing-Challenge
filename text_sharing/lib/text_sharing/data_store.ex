defmodule TextSharing.DataStore do
  use GenServer

  @name DStore

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: DStore])
  end

  def exists?(text_id) do
    GenServer.call(@name, {:exists?, text_id})
  end

  def get_text(text_id) do
    GenServer.call(@name, {:get_text, text_id})
  end

  def update_text(text_id, new_map) do
    GenServer.cast(@name, {:update_text, text_id, new_map})
  end

  def add_new_text(text_id, text) do
    GenServer.cast(@name, {:add_new_text, text_id, text})
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:exists?, text_id}, _from, state) do
    {:reply, Map.has_key?(state, text_id), state}
  end

  def handle_call({:get_text, text_id}, _from, state) do
    {:reply, Map.fetch(state, text_id), state}
  end

  def handle_cast({:update_text, text_id, new_map}, state) do
    {:noreply, Map.update!(state, text_id, fn _old_map -> new_map end)}
  end

  def handle_cast({:add_new_text, text_id, text}, state) do
    {:noreply, Map.put(state, text_id, text)}
  end
end
