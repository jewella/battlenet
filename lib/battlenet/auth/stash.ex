defmodule Battlenet.Auth.Stash do
  use GenServer

  @me __MODULE__

  # API

  def start_link(_args) do
    GenServer.start_link(@me, nil, name: @me)
  end

  def get_access_token() do
    GenServer.call(@me, {:get})
  end

  def update_access_token(new_token) do
    GenServer.cast(@me, {:update, new_token})
  end

  # Server Implementation

  def init(token) do
    {:ok, token}
  end

  def handle_call({:get}, _from, access_token) do
    {:reply, access_token, access_token}
  end

  def handle_cast({:update, new_token}, _access_token) do
    {:noreply, new_token}
  end
end
