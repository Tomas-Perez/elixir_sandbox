defmodule BetterList do
  @moduledoc false
  
  def loop do
    loop([])
  end
  
  defp loop(list) do
    receive do   
      {from, {:store, item} } ->
        send from, {self(), :ok}
        loop [item | list]

      {from, {:take, item}} ->
        if Enum.member?(list, item) do
          send from, {self(), :ok}
          loop List.delete(list, item)
        else
          send from, {self(), :not_found}
          loop list
        end

      {from, {:list}} ->
        send from, {self(), list}
        loop list

      {from, {:terminate}} ->
        send from, {self(), :ok}

    end
  end


end
