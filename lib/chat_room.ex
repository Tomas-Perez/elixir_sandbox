defmodule ChatRoom do
    use GenServer

    def start_link do
        GenServer.start_link(__MODULE__, {%{}, []})
    end

    def join(room_pid, member, member_pid) do
        GenServer.call room_pid, {:join, member, member_pid}
    end

    def talk(room_pid, member, msg) do
        GenServer.cast room_pid, {:talk, member, msg}
    end

    def list_users(room_pid) do
        GenServer.call room_pid, :list_users
    end


    @impl true
    def init(state) do
        {:ok, state}
    end

    @impl true
    def handle_call({:join, name, pid}, _from, state) do
        {members, msgs} = state
        if Map.has_key? members, name do
            {:reply, :name_taken, state}
        else
            new_state = Map.put(members, name, pid)
            {:reply, {:joined, msgs}, {new_state, msgs}}
        end
    end

    @impl true
    def handle_call(:list_users, _from, state) do
        {members, _} = state
        {:reply, Map.keys(members), state}
    end

    @impl true
    def handle_cast({:talk, name, msg_body}, state) do
        {members, msgs} = state
        if Map.has_key? members, name do
            msg = {name, msg_body}
            Enum.each(members, fn {_, pid} -> send pid, {:new_message, msg} end)
            {:noreply, {members, [msg | msgs]}}
        else
            {:noreply, state}
        end
    end


end