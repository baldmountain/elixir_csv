defmodule CSV do
  @moduledoc """
  A REALLY basic CSV parser, just enough to parse basic CSV.

  This code only handles UNIX or MS-DOS newlines. It will fail on old MacOS
  '\r' newlines.
  """

  @normal 0
  @quoted 1

  defrecord State,
    word: "",
    line: [],
    list: [],
    quoted: @normal_state,
    skip_lines: 0

  # def handle_char(c, state, skip_lines, quoted), do:
  def handle_char(c, state, 0, _), do: state.word(state.word <> c)
  def handle_char(^quote_char, state, 0, @normal_state), do: state.quoted(@quoted_state)
  def handle_char(^quote_char, state, 0, @quoted_state), do: state.quoted(@normal_state)

  @doc "Parse a bunch of CSV and return a list of lines parsed as csv"
  def parse(s, separator // ",", quote_char // "\"", skip_lines // 0) do
    # list and line are built reversed since it is more efficient to append to
    # head. They are revered at the end
    state = String.codepoints(s)
    |> Enum.reduce(State[skip_lines: skip_lines], fn c, state ->
      # define thes since we need then in guards
      skip_lines = state.skip_lines
      current_state = state.quoted
      case c do
        "\n" when skip_lines == 0 ->
          state = state.list([Enum.reverse([state.word | state.line]) | state.list])
          state = state.word("")
          state.line([])
        "\n" when skip_lines > 0 ->
          state.skip_lines(state.skip_lines - 1)
        "\r" ->
          nil
        ^separator when current_state == @normal_state and skip_lines == 0 ->
          state = state.line([state.word | state.line])
          state.word("")
        ^quote_char when current_state == @quoted_state and skip_lines == 0 ->
          handle_char(c, state, state.skip_lines, state.quoted)
        ^quote_char when current_state != @quoted_state and skip_lines == 0 ->
          handle_char(c, state, state.skip_lines, state.quoted)
        _  ->
          handle_char(c, state, state.skip_lines, state.quoted)
      end
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