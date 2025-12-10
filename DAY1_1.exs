defmodule Day1 do 	
	def parse(line, acc) do
		newcount = if (rem acc[:pos], 100) == 0 
			do 
				acc[:count] + 1
			else
				acc[:count] 
			end
		case line do 
			"L" <> x -> [count: newcount, pos: acc[:pos] - String.to_integer(x)]
			"R" <> x -> [count: newcount, pos: acc[:pos] + String.to_integer(x)]
		end
	end
end

File.stream!("input_1_1", [:read]) \
|> Enum.map(&String.trim/1)
|> Enum.reduce([count: 0, pos: 50], &Day1.parse/2) \
|> IO.inspect