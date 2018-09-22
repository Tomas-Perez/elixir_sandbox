defmodule Length do

    def length(l) do
        length l, 0
    end

    defp length([_ | t], current) do
        length t, current + 1
    end

    defp length([], current) do
        current
    end
end