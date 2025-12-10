defmodule Day1 do
  def parse(line, acc) do
	
	mirrored = acc[:mirrored]
	
    {newmirrored, stride} =
        case line do
          "L" <> x -> {true, String.to_integer(x)}
          "R" <> x -> {false, String.to_integer(x)}
        end
	
	# mirror position when not already mirrored
	pos = 
		if (mirrored != newmirrored)
		do -acc[:pos]
		else acc[:pos]
		end
		
	newpos = pos + stride
	
	# so we can always compute as if walking to the right
    [
      count: acc[:count] + abs(Integer.floor_div(newpos, 100) - Integer.floor_div(pos, 100)),
      pos: newpos,
	  mirrored: newmirrored
    ]
  end
end

File.stream!("input_1_1", [:read])
|> Enum.map(&String.trim/1)
|> Enum.reduce([count: 0, pos: 50, mirrored: false], &Day1.parse/2)
|> IO.inspect()

ExUnit.start()
defmodule AssertionTest do
  use ExUnit.Case #, async: true
  
  test "RL" do 
	assert Day1.parse("R1", count: 0, pos: 1, mirrored: false) == [count: 0, pos: 2, mirrored: false]
	assert Day1.parse("L1", count: 0, pos: 2, mirrored: false) == [count: 0, pos: -1, mirrored: true]
	assert Day1.parse("L1", count: 0, pos: -1, mirrored: true) == [count: 1, pos: 0, mirrored: true]
	assert Day1.parse("L1", count: 1, pos:  0, mirrored: true) == [count: 1, pos: 1, mirrored: true]
	assert Day1.parse("R1", count: 1, pos: 1, mirrored: true)  == [count: 2, pos: 0, mirrored: false]
  end

end
