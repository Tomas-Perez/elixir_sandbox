defmodule Broker do

    def loop do
        loop(Map.new)
    end

    defp loop(map) do
        receive do
            
            {from, {:new, name, value}} ->
                if Map.has_key? map, name do
                    send from, {self(), :present}
                    loop map
                else
                    send from, {self(), :ok}
                    loop Map.put map, name, [value]
                end

            {from, {:update, name, value}} ->
                history = Map.get map, name
                
                if history != nil do
                    send from, {self(), :ok}
                    loop Map.put map, name, [value | history] 
                else
                    send from, {self(), :not_found}
                    loop map
                end

            {from, {:get_val, name}} ->
                history = Map.get map, name
                
                if history != nil do
                    [h | _] = history
                    send from, {self(), h} 
                else
                    send from, {self(), :not_found}
                end

                loop map

            {from, {:history, name}} ->
                history = Map.get map, name, :not_found
                send from, {self(), history}
                loop map

        end
    end
end