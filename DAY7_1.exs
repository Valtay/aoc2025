defmodule Day7 do
  def parse(line, acc) do
    IO.puts("input is #{line} // #{elem(acc, 0)} #{elem(acc, 1)}")

    {count, prev_pipe_or_dot} = acc
    IO.inspect(parsepartial(count, "", line, prev_pipe_or_dot))
  end

  def parsepartial(activated_splitters, next_line_or_dot, current_line, prev_line) do
    {up, peekupright, rest_prev_line} =
      case prev_line do
        :start_of_document -> {".", ".", :start_of_document}
        :done -> {:done, :done, :done}
        "." -> {".", ".", :done}
        "|" -> {"|", ".", :done}
        _ -> {String.at(prev_line, 0), String.at(prev_line, 1), String.slice(prev_line, 1..-1//1)}
      end

    case current_line do
      "S" <> x ->
        parsepartial(activated_splitters, next_line_or_dot <> "|", x, rest_prev_line)

      ".S" <> x ->
        parsepartial(activated_splitters, next_line_or_dot <> ".", "S" <> x, rest_prev_line)

      ".." <> x ->
        case up do
          "|" ->
            parsepartial(activated_splitters, next_line_or_dot <> "|", "." <> x, rest_prev_line)

          "." ->
            parsepartial(activated_splitters, next_line_or_dot <> ".", "." <> x, rest_prev_line)
        end

      ".^" <> x ->
        case {up, peekupright} do
          {"|", _} ->
            parsepartial(activated_splitters, next_line_or_dot <> "|", "^" <> x, rest_prev_line)

          {_, "|"} ->
            parsepartial(activated_splitters, next_line_or_dot <> "|", "^" <> x, rest_prev_line)

          {_, _} ->
            parsepartial(activated_splitters, next_line_or_dot <> ".", "^" <> x, rest_prev_line)
        end

      "^." <> x ->
        case up do
          "|" ->
            parsepartial(
              activated_splitters + 1,
              next_line_or_dot <> ".|",
              x,
              String.slice(rest_prev_line, 1..-1//1)
            )

          "." ->
            parsepartial(activated_splitters, next_line_or_dot <> ".", "." <> x, rest_prev_line)
        end

      "." ->
        parsepartial(activated_splitters, next_line_or_dot <> ".", "", rest_prev_line)

      "" ->
        {activated_splitters, next_line_or_dot}
    end
  end
end

File.stream!("input_7_1", [:read])
|> Enum.map(&String.trim/1)
|> IO.inspect()
|> Enum.reduce({0, :start_of_document}, &Day7.parse/2)
|> IO.inspect()
