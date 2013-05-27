defmodule CSV do
	@moduledoc """
	A REALLY basic CSV parser, just enough to parse basic CSV.
	"""

	@normal_state 0
	@quoted_state 1

	@doc "Parse a bunch of CSV and return a list of lines parsed as csv"
	def parse(s, separator // ",", quote_char // "\"", skip_lines // 0) do
		{ word, line, list, state, skip_lines } = String.codepoints(s) |> Enum.reduce({ "", [], [], @normal_state, skip_lines }, fn c, { word, line, list, state, skip_lines } ->
			case c do
				"\n" when skip_lines == 0 ->
					list = list ++ [List.flatten([line, word])]
					word = ""
					line = []
				"\n" when skip_lines > 0 ->
					skip_lines = skip_lines - 1
				"\r" ->
					nil
				^separator when state == @normal_state and skip_lines == 0 ->
					line = [line, word]
					word = ""
				^quote_char when state == @quoted_state and skip_lines == 0 ->
					state = @normal_state
				^quote_char when state != @quoted_state and skip_lines == 0 ->
					state = @quoted_state
				_  ->
					if skip_lines == 0, do: word = word <> c
			end
			{ word, line, list, state, skip_lines }
		end)
		line = List.flatten([line, word])
		list = list ++ [line]
		list
	end

	@doc "Parse a file and return a list of lines parsed as CVS"
	def parse_file(filename, separator // ",", quote_char // "\"", skip_lines // 0) do
		{ status, body } = File.read(filename)
		case status do
			:ok -> parse(body, separator, quote_char, skip_lines)
			_ -> []
		end
	end
end