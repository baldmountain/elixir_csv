defmodule CSV do
  @moduledoc """
  A REALLY basic CSV parser, just enough to parse basic CSV.

  This code only handles UNIX or MS-DOS newlines. It will fail on old MacOS
  '\r' newlines.
  """

  @normal_state 0
  @quoted_state 1

  @doc false
  defrecord State,
    word: "",
    line: [],
    list: [],
    state: @normal_state,
    separator: ",",
    quote_char: "\"",
    skip_lines: 0
    
  @doc false
  defp parse_inner(<<>>, state), do: state
  
  @doc false
  defp parse_inner(<< c :: utf8, rest :: binary >>, state) do
    # define thes since we need then in guards
    skip_lines = state.skip_lines
    separator = state.separator
    quote_char = state.quote_char
    current_state = state.state
    c = to_string([c])
    
    parse_inner(rest, case c do
      "\n" when skip_lines == 0 ->
        state.list([Enum.reverse([state.word | state.line]) | state.list]).word("").line([])
      "\n" when skip_lines > 0 ->
        state.skip_lines(state.skip_lines - 1)
      "\r" ->
        state
      ^separator when current_state == @normal_state and skip_lines == 0 ->
        state.line([state.word | state.line]).word("")
      ^quote_char when current_state == @quoted_state and skip_lines == 0 ->
        state.state(@normal_state)
      ^quote_char when current_state != @quoted_state and skip_lines == 0 ->
        state.state(@quoted_state)
      _  ->
        if state.skip_lines == 0, do: state.word(state.word <> c), else: state
    end)
  end

  @doc "Parse a bunch of CSV and return a list of lines parsed as csv"
  def parse(s, separator // ",", quote_char // "\"", skip_lines // 0) do
    # list and line are built reversed since it is mre effieince to append to
    # head. They are revered at the end
    state = parse_inner(s, State[separator: separator, quote_char: quote_char, skip_lines: skip_lines])
    line = Enum.reverse([state.word | state.line])
    list = case line do
      [""] -> state.list
      _ -> [line | state.list]
    end
    Enum.reverse(list)
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