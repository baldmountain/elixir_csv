defmodule CSV do
	@moduledoc """
	A REALLY basic CSV parser, just enough to parse basic CSV.
	"""

	@normal_state 0
	@quoted_state 1

	@doc "Parse a bunch of CSV and return a list of lines parsed as csv"
	def parse(s, separator // ",", quote_char // "\"") do
		{ word, line, list, state } = String.codepoints(s) |> Enum.reduce({ "", [], [], @normal_state }, fn c, { word, line, list, state } ->
			case c do
				"\n" ->
					line = line ++ word
					list = list ++ [line]
					line = []
				^separator when state == @normal_state ->
					line = line ++ [word]
					word = ""
				^quote_char when state == @quoted_state ->
					state = @normal_state
				^quote_char when state != @quoted_state ->
					state = @quoted_state
				_ -> word = word <> c
			end
			{ word, line, list, state }
		end)
		line = line ++ [word]
		list = list ++ [line]
		list
	end
	
end