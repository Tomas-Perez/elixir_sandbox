defmodule ChatSystem do
    use GenServer

    def start_link do
        GenServer.start_link(__MODULE__, %{}, name: {:global, :chat_system})
    end

    def create_room(name) do
        GenServer.call {:global, :chat_system}, {:create, name}
    end

    def lookup_room(name) do
        GenServer.call {:global, :chat_system}, {:lookup, name}
    end

    def list_rooms do
        GenServer.call {:global, :chat_system}, :list
    end


    @impl true
    def init(state) do
        {:ok, state}
    end

    @impl true
    def handle_call({:create, name}, _from, state) do
        if Map.has_key? state, name do
            {:reply, :name_taken, state}
        else
            {:ok, r} = ChatRoom.start_link
            {:reply, r, Map.put(state, name, r)}
        end
    end

    @impl true
    def handle_call({:lookup, name}, _from, state) do
        result = Map.get state, name
        if result != nil do
            {:reply, result, state}
        else
            {:reply, :not_found, state}
        end
    end

    @impl true
    def handle_call(:list, _from, state) do
        {:reply, state, state}
    end
end