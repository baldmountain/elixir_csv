defmodule CSV do
  @moduledoc """
  A REALLY basic CSV parser, just enough to parse basic CSV.

  This code only handles UNIX or MS-DOS newlines. It will fail on old MacOS
  '\r' newlines.
  """

  @normal_state 0
  @quoted_state 1

  defrecord State,
    word: "",
    line: [],
    list: [],
    state: @normal_state,
    skip_lines: 0

  @doc "Parse a bunch of CSV and return a list of lines parsed as csv"
  def parse(s, separator // ",", quote_char // "\"", skip_lines // 0) do
    # list and line are built reversed since it is mre effieince to append to
    # head. They are revered at the end
    state = String.codepoints(s)
    |> Enum.reduce(State[skip_lines: skip_lines], fn c, state ->
      # define thes since we need then in guards
      skip_lines = state.skip_lines
      current_state = state.state
      case c do
        "\n" when skip_lines == 0 ->
          state = state.list([Enum.reverse([state.word | state.line]) | state.list])
          state = state.word("")
          state = state.line([])
        "\n" when skip_lines > 0 ->
          state = state.skip_lines(state.skip_lines - 1)
        "\r" ->
          nil
        ^separator when current_state == @normal_state and skip_lines == 0 ->
          state = state.line([state.word | state.line])
          state = state.word("")
        ^quote_char when current_state == @quoted_state and skip_lines == 0 ->
          state = state.state(@normal_state)
        ^quote_char when current_state != @quoted_state and skip_lines == 0 ->
          state = state.state(@quoted_state)
        _  ->
          if state.skip_lines == 0, do: state = state.word(state.word <> c)
      end
      state
    end)
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