defmodule Day7 do
  def parse(line, prev_line) do
    # IO.puts("[#{Enum.intersperse(String.split(line, "", trim: true), "  ")}] ")
    parsepartial(0, [], line, prev_line)
  end

  def parsepartial(paths_from_left, currentlinepaths_reversed, current_line, prev_line) do
    {up, peekupright, rest_prev_line} =
      case prev_line do
        :start_of_document -> {0, 0, :start_of_document}
        [0 | :start_of_document] -> {0, 0, :start_of_document}
        [path_count_up | []] -> {path_count_up, 0, :done}
        [path_count_up, path_count_upright | tail] -> {path_count_up, path_count_upright, tail}
        [] -> {:err, :err, :done}
        :done -> {:err, :err, :done}
      end

    # IO.puts("up is |#{up} #{peekupright}|  and current is #{current_line}")

    case current_line do
      "S" <> x ->
        parsepartial(
          0,
          [1 + up + paths_from_left | currentlinepaths_reversed],
          x,
          [peekupright | rest_prev_line]
        )

      ".S" <> x ->
        parsepartial(
          0,
          [up + paths_from_left | currentlinepaths_reversed],
          "S" <> x,
          [peekupright | rest_prev_line]
        )

      ".." <> x ->
        parsepartial(
          0,
          [up + paths_from_left | currentlinepaths_reversed],
          "." <> x,
          [peekupright | rest_prev_line]
        )

      ".^" <> x ->
        parsepartial(
          0,
          [up + peekupright + paths_from_left | currentlinepaths_reversed],
          "^" <> x,
          [peekupright | rest_prev_line]
        )

      "^." <> x ->
        parsepartial(
          up + paths_from_left,
          [0 | currentlinepaths_reversed],
          "." <> x,
          [peekupright | rest_prev_line]
        )

      "^." ->
        parsepartial(
          0,
          [peekupright + up + paths_from_left, 0 | currentlinepaths_reversed],
          "",
          rest_prev_line
        )

      "." ->
        parsepartial(
          0,
          [up + paths_from_left | currentlinepaths_reversed],
          "",
          rest_prev_line
        )

      "" ->
        Enum.reverse(currentlinepaths_reversed)
    end
  end
end

File.stream!("input_7_1", [:read])
|> Enum.map(&String.trim/1)
|> Enum.reduce(:start_of_document, &Day7.parse/2)
|> Enum.sum()
|> IO.inspect(label: "Result")
